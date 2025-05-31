//
//  SampleRepository.swift
//
//  SampleDomainInterface
//
//  Created by JiYeon
//

import Foundation

public protocol SampleRepository {
  func fetchData() async throws
}
