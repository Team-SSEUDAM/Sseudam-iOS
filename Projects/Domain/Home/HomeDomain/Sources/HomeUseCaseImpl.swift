//
//  HomeUseCaseImpl.swift
//
//  HomeDomain
//
//  Created by JiYeon
//

import Foundation
import HomeDomainInterface

extension HomeUseCase {
  public static func live(repository: HomeRepository) -> HomeUseCase {
    .init {
      try await repository.fetchData()
    }
  }
  
}
