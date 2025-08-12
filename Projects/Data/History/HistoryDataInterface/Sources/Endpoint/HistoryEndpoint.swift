//
//  HistoryEndpoint.swift
//  HistoryDataInterface
//
//  Created by 조용인 on 8/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import UserDefaults
import HistoryDomainInterface

public enum HistoryEndpoint: Sendable {
  public static func getSuggestionAndHistory() -> Endpoint<SuggestionAndReportHistoryDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .get,
      path: "/histories"
    )
  }
}
