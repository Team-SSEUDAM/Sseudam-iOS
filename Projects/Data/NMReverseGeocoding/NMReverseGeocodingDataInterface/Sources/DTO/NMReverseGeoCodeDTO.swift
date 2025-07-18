//
//  NMReverseGeoCodeDTO.swift
//  NMReverseGeocodingDataInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import Utility
import NMReverseGeocodingDomainInterface

public struct NMReverseGeoCodeDTO: DTO {
  
  public typealias Entity = NMGeoCodeReverseEntity
  
  public let results: [Result]
  
  public struct Result: Decodable & Sendable {
    public let name: String?
    public let code: Code?
    public let region: Region
    public let land: Land?
    
    public struct Code: Decodable & Sendable {
      public let id: String
      public let type: String
      public let mappingId: String
    }
    
    public struct Region: Decodable & Sendable {
      public let area0: Area?
      public let area1: Area
      public let area2: Area
      public let area3: Area
      public let area4: Area?
    }
    
    public struct Area: Decodable & Sendable {
      public let name: String
      public let coords: Coords?
      public let alias: String?
      
      public struct Coords: Decodable & Sendable {
        public let center: Center
        
        public struct Center: Decodable & Sendable {
          public let crs: String
          public let x: Double
          public let y: Double
        }
      }
    }
    
    public struct Land: Decodable & Sendable {
      public let type: String?         // "" or "지번주소"
      public let name: String?         // 도로명
      public let number1: String?      // 건물 번호
      public let number2: String?      // 건물 부번호 (ex: -2)
      public let coords: Coords?
      public let addition0: Addition?  // type: building
      public let addition1: Addition?  // type: zipcode
      public let addition2: Addition?  // type: roadGroupCode
      public let addition3: Addition?
      public let addition4: Addition?
      
      public struct Addition: Decodable & Sendable {
        public let type: String?
        public let value: String?
      }
      
      public struct Coords: Decodable & Sendable {
        public let center: Center
        
        public struct Center: Decodable & Sendable {
          public let crs: String
          public let x: Double
          public let y: Double
        }
      }
    }
  }
}

// MARK: - Priority Logic
extension NMReverseGeoCodeDTO {
  
  /// 우선순위에 따른 결과 선택
  /// 1. 도로명 주소 (land.type이 nil 또는 빈 문자열)
  /// 2. 행정동 (name이 존재하고 land가 nil)
  /// 3. 지번주소 (land.type이 "지번주소")
  private func selectBestResult() -> Result? {
    // 1순위: 도로명 주소 찾기
    if let roadAddressResult = results.first(where: { result in
      result.land != nil && (result.land?.type == nil || result.land?.type == "")
    }) {
      return roadAddressResult
    }
    
    // 2순위: 행정동 찾기
    if let adminResult = results.first(where: { result in
      result.name != nil && result.land == nil
    }) {
      return adminResult
    }
    
    // 3순위: 지번주소 찾기
    if let jibunResult = results.first(where: { result in
      result.land?.type == "지번주소"
    }) {
      return jibunResult
    }
    
    // 우선순위에 맞는 결과가 없으면 첫 번째 결과 반환
    return results.first
  }
  
  public func toEntity() throws -> NMGeoCodeReverseEntity {
    guard let bestResult = selectBestResult() else {
      throw NetworkError.customError(message: "지도 역변환 결과 데이터가 없습니다.")
    }
    
    // 행정구역 정보
    let area1 = bestResult.region.area1.name
    let area2 = bestResult.region.area2.name
    let area3 = bestResult.region.area3.name
    let area4 = bestResult.region.area4?.name
    
    // 주소 조합
    var roadAddress: String
    var zipCode: String?
    
    if let land = bestResult.land {
      // 도로명 또는 지번주소가 있는 경우
      let roadName = land.name
      let number1 = land.number1
      let number2 = land.number2
      
      // 건물명 찾기
      let buildingName = land.addition0?.type == "building" ? land.addition0?.value : nil
      
      // 우편번호 찾기
      zipCode = [land.addition0, land.addition1, land.addition2, land.addition3, land.addition4]
        .compactMap { $0 }
        .first(where: { $0.type == "zipcode" })?
        .value
      
      // 주소 조합
      var addressComponents = [area1, area2]
      
      if let roadName = roadName {
        addressComponents.append(roadName)
      }
      
      if let number1 = number1 {
        if let number2 = number2, !number2.isEmpty {
          addressComponents.append("\(number1)-\(number2)")
        } else {
          addressComponents.append(number1)
        }
      }
      
      let baseAddress = addressComponents.joined(separator: " ")
      
      // 건물명이 있으면 괄호로 추가
      roadAddress = (buildingName != nil && buildingName != "") ? "\(baseAddress) (\(buildingName!))" : baseAddress
      
    } else if let adminName = bestResult.name {
      // 행정동만 있는 경우
      let cleanAdminName = adminName.replacingOccurrences(of: "admcode", with: "")
      roadAddress = [area1, area2, cleanAdminName].joined(separator: " ")
    } else {
      // 기본: area3까지 사용
      roadAddress = [area1, area2, area3].joined(separator: " ")
    }
    
    return NMGeoCodeReverseEntity(
      area1: area1,
      area2: area2,
      area3: area3,
      area4: area4,
      roadAddress: roadAddress,
      zipCode: zipCode
    )
  }
}
