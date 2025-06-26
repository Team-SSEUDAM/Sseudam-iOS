//
//  TrashSpotRepositoryImpl.swift
//
//  TrashSpot
//
//  Created by JiYeon
//

import Foundation
import TrashSpotDomainInterface
import TrashSpotDataInterface
import NetworkKit

public extension TrashSpotRepository {
  static func live(networker: NetworkKit) -> TrashSpotRepository {
    .init(
      fetchTrashSpot: { parameter in
        let endpoint = TrashSpotEndPoint.fetchTrashSpot(parameter: parameter)
        return try await networker.execute(with: endpoint, timeout: 60).toEntity()
      
    })
  }
}
