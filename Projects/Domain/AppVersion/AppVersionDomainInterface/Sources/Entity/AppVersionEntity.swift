//
//  AppVersionEntity.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import Foundation

public struct AppVersionEntity: Codable, Equatable {
  public let newVersion: String
  public var userVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
  }
  public let criticalVersion: String

  public init(
    version: String,
    criticalVersion: String
  ) {
    self.newVersion = version
    self.criticalVersion = criticalVersion
  }
  
  public var updateStatus: UpdateStatus {
    guard userVersion < newVersion else { return .notNeeded } // 새 버전이 더 높을 때만 업데이트 필요
    return criticalVersion >= userVersion // 유저 버전이 치명적 버전보다 낮으면 필수 업데이트
    ? .required
    : .optional
  }
  
  public enum UpdateStatus: Equatable {
    case required
    case optional
    case notNeeded
  }
}
