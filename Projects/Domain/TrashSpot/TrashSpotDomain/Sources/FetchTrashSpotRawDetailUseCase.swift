//
//  FetchTrashSpotRawDetailUseCase.swift
//  TrashSpotDomain
//
//  Created by 조용인 on 7/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface

extension FetchTrashSpotRawDetailUseCase {
  public static func live(repository: TrashSpotRepository) -> FetchTrashSpotRawDetailUseCase {
    .init { data in
      try await repository.fetchTrashSpotDetailFlatten(data)
    }
  }
}
