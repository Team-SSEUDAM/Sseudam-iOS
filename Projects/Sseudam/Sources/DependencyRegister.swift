//
//  DependencyRegister.swift
//  Sseudam
//
//  Created by Jiyeon on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import NMReverseGeocodingDomain
import SuggestionDomain

import NMReverseGeocodingDomainInterface
import SuggestionDomainInterface

import NMReverseGeocodingData
import SuggestionData

import AuthDomainInterface
import AuthDomain
import AuthDataInterface
import AuthData

import UserDomainInterface
import UserDomain
import UserDataInterface
import UserData

import TrashSpotDomainInterface
import TrashSpotDomain
import TrashSpotDataInterface
import TrashSpotData

import NetworkKit

/// 비즈니스 로직의 의존성을 주입하기 위한 구조체
struct DependencyRegister {
  /// UseCase에 Repository 주입
  func injection() {
    let networker = NetworkKit()
    let authRepository = AuthRepository.live(networker: networker)
    let userReoository = UserRepository.live(networker: networker)
    let trashSpotRepository = TrashSpotRepository.live(networker: networker)
    
    let nmGeometryRepository = NMReverseGeoCodeRepository.live
    let suggestionRepository = SpotSuggestionRepository.live

    // MARK: - Home
      
    NMReverseGeoCodeUseCaseRegister(
      provider: {
        NMReverseGeoCodeUseCase.live(repository: nmGeometryRepository)
      }
    )
    
    /// Suggestion
    SpotSuggestionUseCaseRegister(
      provider: {
        SpotSuggestionUseCase.live(repository: suggestionRepository)
      }
    )
    
    UploadSpotImageUseCaseRegister(
      provider: {
        UploadSpotImageUseCase.live(repository: suggestionRepository)
      }
    )
    
    SpotNameValidateUseCaseRegister(
      provider: {
        SpotNameValidateUseCase.live(repository: suggestionRepository)
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
    
    // MARK: - Trash Spot
    
    FetchTrashSpotUseCaseRegister {
      FetchTrashSpotUseCase.live(repository: trashSpotRepository)
    }
    
    FetchTrashSpotDetailUseCaseRegister {
      FetchTrashSpotDetailUseCase.live(repository: trashSpotRepository)
    }
    
  }
}
