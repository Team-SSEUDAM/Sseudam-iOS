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
import Core

public extension SuggestionRepository {
  static var live: SuggestionRepository {
    SuggestionRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
