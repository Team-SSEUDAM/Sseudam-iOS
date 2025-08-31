//
//  AppVersionDTO.swift
//
//  AppVersion
//
//  Created by yongin
//

import Foundation
import AppVersionDomainInterface
import NetworkKit

public struct AppVersionDTO: DTO {
  let deviceType: String
  let currentVersion: String
  let criticalVersion: String
  
  public func toEntity() throws -> AppVersionEntity {
    return  .init(
      version: self.currentVersion,
      criticalVersion: self.criticalVersion
    )
  }
}

