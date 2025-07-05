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
  public static func test(repository: TrashSpotRepository) -> FetchTrashSpotDetailUseCase {
    .init { data in
      return .init(
        id: 1,
        suggestionerId: 1,
        suggestionerName: "김지연",
        name: "구파발역 2번출구",
        address: "서울시 은평구 진관동",
        point: .init(latitude: 11.0, longitude: 11.0),
        trashType: .general,
        visitedCount: 5,
        imageUrl: nil
      )
    }
  }
}
