//
//  PetUseCaseImpl.swift
//
//  PetDomain
//
//  Created by yongin
//

import Foundation
import PetDomainInterface

extension PetUseCase {
  public static func live(repository: PetRepository) -> PetUseCase {
    .init {
      try await repository.fetchData()
    }
  }
}
