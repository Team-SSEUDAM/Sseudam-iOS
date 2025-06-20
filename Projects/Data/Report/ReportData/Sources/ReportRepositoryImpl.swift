//
//  ReportRepositoryImpl.swift
//
//  Report
//
//  Created by yongin
//

import Foundation
import ReportDomainInterface
import ReportDataInterface

public extension ReportRepository {
  static var live: ReportRepository {
    ReportRepository(
      fetchData: {
        // 실제 네트워크 작업 구현
        return
      }
    )
  }
}
