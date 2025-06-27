//
//  SignUpUseCaseImpl.swift
//  AuthDomain
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AuthDomainInterface

extension SignUpUseCase {
  public static func live(repository: AuthRepository) -> SignUpUseCase {
    .init { email, nickname, address in
      try await repository.requestSignUp(email, nickname, address)
    }
  }
  
}
