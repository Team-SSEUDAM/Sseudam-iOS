//
//  UploadSpotImageUseCaseImpl.swift
//  SuggestionDomain
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import SuggestionDomainInterface

extension UploadSpotImageUseCase {
  public static func live(repository: SpotSuggestionRepository) -> UploadSpotImageUseCase {
    .init { image, presignedUrl in
      let input = UploadSpotImageInput(image: image, presignedUrl: presignedUrl)
      let _ = try await repository.putSpotImage(input)
    }
  }
}
