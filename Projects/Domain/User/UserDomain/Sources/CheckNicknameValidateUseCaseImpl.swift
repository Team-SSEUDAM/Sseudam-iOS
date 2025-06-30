//
//  CheckNicknameValidateUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension CheckNicknameValidateUseCase {
  public static func test(repository: UserRepository) -> CheckNicknameValidateUseCase {
    .init { nickname in
      try await repository.checkNicknameValidate(nickname)
    }
  }
}
