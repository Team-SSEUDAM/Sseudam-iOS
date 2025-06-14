//
//  HomeUseCaseImpl.swift
//
//  HomeDomain
//
//  Created by JiYeon
//

import Foundation
import HomeDomainInterface

public struct HomeUseCaseImpl: HomeUseCase {
  private let repository: HomeRepository

  public init(
    repository: HomeRepository
  ) {
    self.repository = repository
  }

  public func execute() async throws { }
}
