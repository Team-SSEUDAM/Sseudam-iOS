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
      return testData[data] ?? .init(
        id: 1,
        suggestionerId: 1,
        suggestionerName: "지연",
        name: "우리집",
        address: "서울시 은평구 진관동",
        point: .init(latitude: 37.643421545524795, longitude: 126.9201620274132),
        trashType: .recycle,
        visitedCount: 10,
        imageUrl: nil
      )
    }
  }
}
 
let testData: [Int: TrashSpotDetail] = [
  1: .init(
  id: 1,
  suggestionerId: 1,
  suggestionerName: "지연",
  name: "우리집",
  address: "서울시 은평구 진관동",
  point: .init(latitude: 37.643421545524795, longitude: 126.9201620274132),
  trashType: .recycle,
  visitedCount: 10,
  imageUrl: nil
),
  2: .init(
    id: 1,
    suggestionerId: 1,
    suggestionerName: "지연",
    name: "test2",
    address: "서울시 은평구 진관동",
    point: .init(latitude: 37.6440, longitude: 126.9205),
    trashType: .recycle,
    visitedCount: 10,
    imageUrl: nil
  ),
  3: .init(
    id: 1,
    suggestionerId: 1,
    suggestionerName: "지연",
    name: "test3",
    address: "서울시 은평구 진관동",
    point: .init(latitude: 37.6428, longitude: 126.9198),
    trashType: .recycle,
    visitedCount: 10,
    imageUrl: nil
  )
]

