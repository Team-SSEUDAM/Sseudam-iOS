//
//  TrashSpotEndPoint.swift
//  TrashSpotDataInterface
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface
import NetworkKit

public struct TrashSpotEndPoint: Sendable {
  public static func fetchTrashSpot(parameter: FetchTrashSpotParameter) -> Endpoint<TrashSpotListDTO> {
    return Endpoint(
      method: .get,
      path: "/trash-spots",
      parameters: .query(parameter)
    )
  }
  
  public static func fetchTrashSpotDetail(spotId: Int) -> Endpoint<TrashSpotDetailDTO> {
    return Endpoint(
      method: .get,
      path: "/trash-spots/\(spotId)"
    )
  }
}

