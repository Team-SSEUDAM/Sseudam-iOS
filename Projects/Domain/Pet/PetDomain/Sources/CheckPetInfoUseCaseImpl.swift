//
//  CheckPetInfoUseCaseImpl.swift
//
//  PetDomain
//
//  Created by yongin
//

import Foundation
import Utility
import PetDomainInterface

extension CheckPetInfoUseCase {
  public static func live(repository: PetRepository) -> CheckPetInfoUseCase {
    .init {
      do {
        let entity = try await repository.getPetInfoFromCache()
        return entity
      } catch let error as CacheError {
        switch error {
        case .fileNotFound:
          let newEntity = try await repository.getPetInfo()
          return newEntity
        default : throw error
        }
      }
    }
  }
}
