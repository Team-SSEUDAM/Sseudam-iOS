//
//  VisitedRepositoryImpl.swift
//
//  Visited
//
//  Created by JiYeon
//

import Foundation
import VisitedDomainInterface
import VisitedDataInterface
import NetworkKit

public extension VisitedRepository {
  static func live(networker: NetworkKit) -> VisitedRepository {
    VisitedRepository(
      requestVisited: { userId, spotId in
        let parameter = VisitedParameter(user: userId)
        let endPoint = VisitedEndPoint.visited(parameter: parameter, spotId: spotId)
        return try await networker.execute(with: endPoint, timeout: 30).toEntity()
      }
    )
  }
}
