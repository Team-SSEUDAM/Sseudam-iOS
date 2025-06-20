//
//  ReportUseCaseImpl.swift
//
//  ReportDomain
//
//  Created by yongin
//

import Foundation
import ReportDomainInterface

extension ReportUseCase {
  public static func live(repository: ReportRepository) -> ReportUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
