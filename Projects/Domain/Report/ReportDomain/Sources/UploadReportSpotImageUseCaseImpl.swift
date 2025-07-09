//
//  UploadReportSpotImageUseCaseImpl.swift
//  ReportDomain
//
//  Created by 조용인 on 7/7/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ReportDomainInterface

extension UploadReportSpotImageUseCase {
  public static func live(repository: ReportRepository) -> UploadReportSpotImageUseCase {
    .init { image, presignedUrl in
      let input = UploadReportSpotImageInput(image: image, presignedUrl: presignedUrl)
      let _ = try await repository.putReportSpotImage(input)
    }
  }
}
