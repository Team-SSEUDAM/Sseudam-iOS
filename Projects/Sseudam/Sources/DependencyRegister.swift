//
//  DependencyRegister.swift
//  Sseudam
//
//  Created by Jiyeon on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import HomeDomain
import NMReverseGeocodingDomain
import SuggestionDomain

import HomeDomainInterface
import NMReverseGeocodingDomainInterface
import SuggestionDomainInterface

import HomeData
import NMReverseGeocodingData
import SuggestionData

/// 비즈니스 로직의 의존성을 주입하기 위한 구조체
struct DependencyRegister {
  /// UseCase에 Repository 주입
  func injection() {
    let homeRepository = HomeRepository.live
    let nmGeometryRepository = NMReverseGeoCodeRepository.live
    let suggestionRepository = SpotSuggestionRepository.live
    
    HomeUseCaseRegister(
      provider: {
        HomeUseCase.live(repository: homeRepository)
      }
    )
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
    
  }
}
