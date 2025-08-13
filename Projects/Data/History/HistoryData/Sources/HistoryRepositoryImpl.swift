//
//  HistoryRepositoryImpl.swift
//
//  History
//
//  Created by yongin
//

import Foundation
import HistoryDomainInterface
import HistoryDataInterface
import NetworkKit

public extension HistoryRepository {
    static func live(networker: NetworkKit) -> HistoryRepository {
    return .init(
      getSuggestionAndHistory: {
        let endpoint = HistoryEndpoint.getSuggestionAndHistory()
        return try await networker.execute(with: endpoint).toEntity()
      }
    )
  }
}
