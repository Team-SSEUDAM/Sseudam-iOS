//
//  CheckPetInfoUseCaseImpl.swift
//
//  PetDomain
//
//  Created by yongin
//

import Foundation
import PetDomainInterface

extension CheckPetInfoUseCase {
  public static func live(repository: PetRepository) -> CheckPetInfoUseCase {
    .init {
      let entity = try await repository.getPetInfo()
      return entity
    }
  }
}
