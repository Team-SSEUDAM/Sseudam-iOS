//
//  ChangePetNicknameUseCaseImpl.swift
//  PetDomain
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import PetDomainInterface

extension ChangePetNicknameUseCase {
  public static func live(repository: PetRepository) -> ChangePetNicknameUseCase {
    .init { nickname in
      do {
        try await repository.putPetNickname(nickname)
      } catch let error as NetworkError {
        throw error
      }
    }
  }
}
