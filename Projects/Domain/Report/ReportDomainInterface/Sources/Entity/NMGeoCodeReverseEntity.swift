//
//  NMGeoCodeReverseEntity.swift
//  ReportDomainInterface
//
//  Created by 조용인 on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct NMGeoCodeReverseEntity: Equatable, Codable {
  public let area1: String
  public let area2: String
  public let area3: String
  public let area4: String?
  public let roadAddress: String?
  public let zipCode: String?
  
  public var region: String {
    switch area1 {
    case "서울특별시": return "SEOUL"
    case "경기도": return "GYEONGGI"
    case "부산광역시": return "BUSAN"
    case "대구광역시": return "DAEGU"
    case "인천광역시": return "INCHEON"
    case "광주광역시": return "GWANGJU"
    case "대전광역시": return "DAEJEON"
    case "울산광역시": return "ULSAN"
    case "세종특별자치시": return "SEJONG"
    case "강원도": return "GANGWON"
    case "충청북도": return "CHUNGBUK"
    case "충청남도": return "CHUNGNAM"
    case "전라북도": return "JEONBUK"
    case "전라남도": return "JEONNAM"
    case "경상북도": return "GYEONGBUK"
    case "경상남도": return "GYEONGNAM"
    case "제주특별자치도": return "JEJU"
    default: return "UNKNOWN"
    }
  }

  
  /// 구/군
  public var city: String {
    area2
  }
  
  /// 시/도 + 구 + 나머지 (건물명 제거된 roadAddress 기준)
  public var site: String {
    // 괄호 제거 (건물명 제거)
    let roadWithoutBuilding = roadAddress?.components(separatedBy: " (").first ?? ""
    return [region, city, roadWithoutBuilding]
      .filter { !$0.isEmpty }
      .joined(separator: " ")
  }
  
  public init(
    area1: String,
    area2: String,
    area3: String,
    area4: String?,
    roadAddress: String?,
    zipCode: String?
  ) {
    self.area1 = area1
    self.area2 = area2
    self.area3 = area3
    self.area4 = area4
    self.roadAddress = roadAddress
    self.zipCode = zipCode
  }
}
