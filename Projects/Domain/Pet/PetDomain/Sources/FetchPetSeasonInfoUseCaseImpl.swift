//
//  FetchPetSeasonInfoUseCaseImpl.swift
//  PetDomain
//
//  Created by 조용인 on 7/18/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import PetDomainInterface

extension FetchPetSeasonInfoUseCase {
  public static func live(repository: PetRepository) -> FetchPetSeasonInfoUseCase {
    .init {
      do {
        let entity = try await repository.getPetSeasonInfoFromCache()
        return entity
      } catch let error as CacheError {
        switch error {
        case .fileNotFound:
          let newEntity = try await repository.getPetSeasonInfo()
          return newEntity
        default : throw error
        }
      }
    }
  }
}
