//
//  FetchTrashSpotDetailUseCase.swift
//  TrashSpotDomain
//
//  Created by Jiyeon on 7/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface
import Utility

extension FetchTrashSpotDetailUseCase {
  public static func live(repository: TrashSpotRepository) -> FetchTrashSpotDetailUseCase {
    .init { data in
      do {
        let data = try await repository.fetchTrashSpotDetailCache(data)
        return data
      } catch let error as CacheError {
        switch error {
        case .fileNotFound:
          let data = try await repository.fetchTrashSpotDetail(data)
          return data
          
        default: throw error
        }
      }
      
    }
  }
}

