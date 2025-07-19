//
//  DependencyRegister.swift
//  Sseudam
//
//  Created by Jiyeon on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import NMReverseGeocodingDomainInterface
import NMReverseGeocodingDomain
import NMReverseGeocodingData

import SuggestionDomainInterface
import SuggestionDomain
import SuggestionData

import ReportDomainInterface
import ReportDomain
import ReportData

import AuthDomainInterface
import AuthDomain
import AuthData

import UserDomainInterface
import UserDomain
import UserData

import TrashSpotDomainInterface
import TrashSpotDomain
import TrashSpotData

import PetDomainInterface
import PetDomain
import PetData

import VisitedDomainInterface
import VisitedDomain
import VisitedData

import NetworkKit

/// 비즈니스 로직의 의존성을 주입하기 위한 구조체
struct DependencyRegister {
  /// UseCase에 Repository 주입
  func injection() {
    let networker = NetworkKit()
    let authRepository = AuthRepository.live(networker: networker)
    let userReoository = UserRepository.live(networker: networker)
    let trashSpotRepository = TrashSpotRepository.live(networker: networker)
    let reportRepository = ReportRepository.live(networker: networker)
    let petRepository = PetRepository.live(networker: networker)
    let visitedRepository = VisitedRepository.live(networker: networker)
    
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
    
    // MARK: - Report
    ReportSpotUseCaseRegister {
      ReportSpotUseCase.live(repository: reportRepository)
    }
    
    UploadReportSpotImageUseCaseRegister {
      UploadReportSpotImageUseCase.live(repository: reportRepository)
    }
    
    ReportSpotNameValidateUseCaseRegister {
      ReportSpotNameValidateUseCase.live(repository: reportRepository)
    }
    
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
    
    LogoutUseCaseRegister {
      LogoutUseCase.live(repository: authRepository)
    }
    
    TokenDeleteUseCaseRegister {
      TokenDeleteUseCase.live
    }
    
    // MARK: - User
    
    CheckNicknameValidUseCaseRegister {
      CheckNicknameValidateUseCase.live(repository: userReoository)
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
    
    WithdrawalUseCaseRegister {
      WithdrawalUseCase.live(repository: userReoository)
    }
    
    FetchUserInfoUseCaseRegister {
      FetchUserInfoUseCase.live(repository: userReoository)
    }
    
    // MARK: - Trash Spot
    
    FetchTrashSpotUseCaseRegister {
      FetchTrashSpotUseCase.live(repository: trashSpotRepository)
//      FetchTrashSpotUseCase.test
    }
    
    FetchTrashSpotDetailUseCaseRegister {
      FetchTrashSpotDetailUseCase.live(repository: trashSpotRepository)
    }
    
    FetchTrashSpotRawDetailUseCaseRegister {
      FetchTrashSpotRawDetailUseCase.live(repository: trashSpotRepository)
    }
    
    CheckPetInfoUseCaseRegister {
      CheckPetInfoUseCase.live(repository: petRepository)
    }
    
<<<<<<< HEAD
    FetchPetSeasonInfoUseCaseRegister {
      FetchPetSeasonInfoUseCase.live(repository: petRepository)
=======
    // MARK: - Visited
    
    VisitedUseCaseRegister {
      VisitedUseCase.live(repository: visitedRepository)
>>>>>>> 6f4d10d (feat: #37 인증하기 api 연결 작업)
    }
    
    CheckRecentVisitUseCaseRegister {
      CheckRecentVisitUseCase.live(repository: visitedRepository)
    }
  }
}
