//
//  FetchTrashSpotDetailUseCase.swift
//  TrashSpotDomain
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface

extension FetchTrashSpotDetailUseCase {
  public static func live(repository: TrashSpotRepository) -> FetchTrashSpotDetailUseCase {
    .init { data in
      try await repository.fetchTrashSpotDetail(data)
    }
  }
}

