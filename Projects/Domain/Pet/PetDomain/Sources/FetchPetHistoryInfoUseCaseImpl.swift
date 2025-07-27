//
//  FetchPetHistoryInfoUseCaseImpl.swift
//  PetDomain
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import PetDomainInterface

extension FetchPetHistoryInfoUseCase {
  public static func live(repository: PetRepository) -> FetchPetHistoryInfoUseCase {
    .init {
      do {
        let entity = try await repository.getPetHistoryInfoFromCache()
        return entity
      } catch let error as CacheError {
        switch error {
        case .fileNotFound:
          let newEntity = try await repository.getPetHistoryInfo()
          return newEntity
        default : throw error
        }
      }
    }
  }
}
