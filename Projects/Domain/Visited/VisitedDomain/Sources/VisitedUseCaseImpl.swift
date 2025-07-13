//
//  VisitedUseCaseImpl.swift
//
//  VisitedDomain
//
//  Created by JiYeon
//

import Foundation
import VisitedDomainInterface

extension VisitedUseCase {
  public static func live(repository: VisitedRepository) -> VisitedUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
