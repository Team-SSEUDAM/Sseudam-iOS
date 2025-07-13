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
  static var live: VisitedRepository {
    VisitedRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
