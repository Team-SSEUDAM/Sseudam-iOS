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
import UserDefaults

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
          if UserDefaultsKeys.current_catlevel ?? 1 < newEntity.levelType.rawInt {
            UserDefaultsKeys.isNeedLevelUp = true
          }
          return newEntity
        default : throw error
        }
      }
    }
  }
}
