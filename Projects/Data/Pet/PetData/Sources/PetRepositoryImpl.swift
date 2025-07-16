//
//  PetRepositoryImpl.swift
//
//  Pet
//
//  Created by yongin
//

import Foundation
import PetDomainInterface
import PetDataInterface
import NetworkKit

public extension PetRepository {
  static func live(networker: NetworkKit) -> PetRepository {
    return .init(
      getPetInfo: {
        let endpoint = PetEndpoint.getPetInfo()
        return try await networker.execute(with: endpoint).toEntity()
      }
    )
  }
}
