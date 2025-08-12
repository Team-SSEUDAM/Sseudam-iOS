//
//  ChangeNicknameUseCaseImpl.swift
//  UserDomain
//
//  Created by 조용인 on 8/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension ChangeNicknameUseCase {
  public static func live(repository: UserRepository) -> ChangeNicknameUseCase {
    .init { nickname in
      try await repository.changeNickname(nickname)
    }
  }
}
