//
//  DependencyRegister.swift
//  Sseudam
//
//  Created by Jiyeon on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//


import HomeDomainInterface
import HomeDomain
import HomeDataInterface
import HomeData

import AuthDomainInterface
import AuthDomain
import AuthDataInterface
import AuthData

import UserDomainInterface
import UserDomain
import UserDataInterface
import UserData
import NetworkKit

/// 비즈니스 로직의 의존성을 주입하기 위한 구조체
struct DependencyRegister {
  /// UseCase에 Repository 주입
  func injection() {
    let networker = NetworkKit()
    let homeRepository = HomeRepository.live
    let authRepository = AuthRepository.live(networker: networker)
    let userReoository = UserRepository.live(networker: networker)
    
    // MARK: - Home
    
    HomeUseCaseRegister(
      provider: {
        HomeUseCase.live(repository: homeRepository)
      }
    )
    
    // MARK: - Auth
    
    AppleLoginUseCaseRegister {
      AppleLoginUseCase.live(repository: authRepository)
    }
    
    TokenSaveUseCaseRegister {
      TokenSaveUseCase.live()
    }
    
    SignUpUseCaseRegister {
      SignUpUseCase.live(repository: authRepository)
    }
    
    // MARK: - User
    
    CheckNicknameValidUseCaseRegister {
      CheckNicknameValidateUseCase.test(repository: userReoository)
    }
    
    LoadAreaListUseCaseRegister {
      LoadAreaListUseCase.live(repository: userReoository)
    }
    
    DeleteAreaListUseCaseRegister {
      DeleteAreaListUseCase.live(repository: userReoository)
    }
    
    SearchAreaUseCaseRegister {
      SearchAreaUseCase.live(repository: userReoository)
    }
    
  }
}
