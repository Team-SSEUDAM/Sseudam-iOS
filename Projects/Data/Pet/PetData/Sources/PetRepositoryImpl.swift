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
  static var live: PetRepository {
    PetRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
