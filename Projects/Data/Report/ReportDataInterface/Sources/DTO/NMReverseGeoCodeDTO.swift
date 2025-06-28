//
//  NMReverseGeoCodeDTO.swift
//  Report
//
//  Created by yongin
//

import Foundation
import NetworkKit
import Utility
import ReportDomainInterface

public struct NMReverseGeoCodeDTO: DTO {
  
  public typealias Entity = NMGeoCodeReverseEntity
  
  public let results: [Result]
  
  public struct Result: Decodable & Sendable {
    public let region: Region
    public let land: Land?
    
    public struct Region: Decodable & Sendable {
      public let area1: Area
      public let area2: Area
      public let area3: Area
      public let area4: Area?
    }
    
    public struct Area: Decodable & Sendable {
      public let name: String
      public let alias: String?
    }
    
    public struct Land: Decodable & Sendable {
      public let name: String?         // 도로명
      public let number1: String?      // 건물 번호
      public let number2: String?      // 건물 부번호 (ex: -2)
      public let addition0: Addition?  // type: building
      public let addition1: Addition?  // type: zipcode
      public let addition2: Addition?  // type: roadGroupCode
      public let addition3: Addition?
      public let addition4: Addition?
      
      public struct Addition: Decodable & Sendable {
        public let type: String?
        public let value: String?
      }
    }
  }
}

extension NMReverseGeoCodeDTO {
  public func toEntity() throws -> NMGeoCodeReverseEntity {
    guard let result = results.first else {
      throw NetworkError.customError(message: "지도 역변환 결과 데이터가 없습니다.")
    }
    
    // 행정구역 정보
    let area1 = result.region.area1.name
    let area2 = result.region.area2.name
    let area3 = result.region.area3.name
    let area4 = result.region.area4?.name
    
    // 도로명 주소 조합
    let roadName = result.land?.name
    let number1 = result.land?.number1
    let buildingName = result.land?.addition0?.type == "building" ? result.land?.addition0?.value : nil
    let zipCode = result.land?.addition1?.type == "zipcode" ? result.land?.addition1?.value : nil
    
    let fullRoadAddress = [area1, area2, roadName, number1]
      .compactMap { $0 }
      .joined(separator: " ")
    
    let roadAddress = buildingName != nil ? "\(fullRoadAddress) (\(buildingName!))" : fullRoadAddress
    
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
