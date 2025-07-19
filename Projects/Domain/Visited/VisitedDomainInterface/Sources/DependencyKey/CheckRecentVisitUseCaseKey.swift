//
//  CheckRecentVisitUseCaseKey.swift
//  VisitedDomainInterface
//
//  Created by Jiyeon on 7/19/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Dependencies

public enum CheckRecentVisitUseCaseKey: DependencyKey {
  public static var liveValue: CheckRecentVisitUseCase { CheckRecentVisitUseCaseProvider() }
  public static var previewValue: CheckRecentVisitUseCase { CheckRecentVisitUseCaseProvider() }
  public static var testValue: CheckRecentVisitUseCase { CheckRecentVisitUseCaseProvider() }
}

private var CheckRecentVisitUseCaseProvider: () -> CheckRecentVisitUseCase = {
  fatalError("VisitedUseCase Dependency not configured")
}

public func CheckRecentVisitUseCaseRegister(
  provider: @escaping () -> CheckRecentVisitUseCase
) {
  CheckRecentVisitUseCaseProvider = provider
}

extension DependencyValues {
  public var CheckRecentVisitUseCase: CheckRecentVisitUseCase {
    get { self[CheckRecentVisitUseCaseKey.self] }
    set { self[CheckRecentVisitUseCaseKey.self] = newValue }
  }
}
