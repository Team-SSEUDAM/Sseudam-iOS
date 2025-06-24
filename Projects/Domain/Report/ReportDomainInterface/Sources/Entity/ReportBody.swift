//
//  ReportEntity.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import Foundation

public struct ReportBody: Equatable {
  /// 신고할 위치
  public var location: ReportMapPoint?
  /// 신고할 이름
  public var name: String?
  /// 신고할 종류
  public var kind: String?
  
  public init() {}
}


