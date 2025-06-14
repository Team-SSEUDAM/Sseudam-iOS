//
//  HomeRepository.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import Foundation

public protocol HomeRepository {
  func fetchData() async throws -> Void
}
