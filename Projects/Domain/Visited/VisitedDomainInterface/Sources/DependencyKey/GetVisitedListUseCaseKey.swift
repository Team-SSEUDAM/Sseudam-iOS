//
//  GetVisitedListUseCaseKey.swift
//  VisitedDomainInterface
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum GetVisitedListUseCaseKey: DependencyKey {
  public static var liveValue: GetVisitedListUseCase { GetVisitedListUseCaseProvider() }
  public static var previewValue: GetVisitedListUseCase { GetVisitedListUseCaseProvider() }
  public static var testValue: GetVisitedListUseCase { GetVisitedListUseCaseProvider() }
}

private var GetVisitedListUseCaseProvider: () -> GetVisitedListUseCase = {
  fatalError("GetVisitedListUseCase Dependency not configured")
}

public func GetVisitedListUseCaseRegister(
  provider: @escaping () -> GetVisitedListUseCase
) {
  GetVisitedListUseCaseProvider = provider
}

extension DependencyValues {
  public var GetVisitedListUseCase: GetVisitedListUseCase {
    get { self[GetVisitedListUseCaseKey.self] }
    set { self[GetVisitedListUseCaseKey.self] = newValue }
  }
}
