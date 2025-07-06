//
//  FetchTrashSpotUseCaseImpl.swift
//  TrashSpotDomain
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface

extension FetchTrashSpotUseCase {
  public static func live(repository: TrashSpotRepository) -> FetchTrashSpotUseCase {
    .init { data in
      try await repository.fetchTrashSpot(data)
    }
  }
}
