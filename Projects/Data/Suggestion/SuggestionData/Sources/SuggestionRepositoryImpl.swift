//
//  SuggestionRepositoryImpl.swift
//
//  Suggestion
//
//  Created by yongin
//

import Foundation
import SuggestionDomainInterface
import SuggestionDataInterface
import NetworkKit

public extension SpotSuggestionRepository {
  static var live: SpotSuggestionRepository {
    return .init(
      postSpotSuggestion: { input in
        let body = SpotSuggestionBody(input)
        let endpoint = SuggestionEndpoint.postSpotSuggestion(body: body)
        return try await NetworkKit().execute(with: endpoint).toEntity()
      }
    )
  }
}
