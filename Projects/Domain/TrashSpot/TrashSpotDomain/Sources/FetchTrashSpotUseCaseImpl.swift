//
//  FetchTrashSpotUseCaseImpl.swift
//  TrashSpotDomain
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface
import Utility

extension FetchTrashSpotUseCase {
  public static func live(repository: TrashSpotRepository) -> FetchTrashSpotUseCase {
    .init { data in
      try await repository.fetchTrashSpot(data)
    }
  }
  
  public static var test: FetchTrashSpotUseCase {
    return .init { _ in
      [
        .init(
          id: 1,
          name: "진관 휴지통 A",
          region: "은평구",
          address: "서울시 은평구 진관3로 77",
          location: Coordinates(latitude: 37.643421545524795, longitude: 126.9201620274132),
          trashType: .general
        ),
        .init(
          id: 2,
          name: "진관 휴지통 B",
          region: "은평구",
          address: "서울시 은평구 진관3로 79",
          location: Coordinates(latitude: 37.6440, longitude: 126.9205),
          trashType: .recycle
        ),
        .init(
          id: 3,
          name: "진관 휴지통 C",
          region: "은평구",
          address: "서울시 은평구 진관3로 75",
          location: Coordinates(latitude: 37.6428, longitude: 126.9198),
          trashType: .general
        )
      ]
    }
  }
}
