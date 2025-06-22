//
//  AppleLoginHelper.swift
//  Utility
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import UIKit

/// AppleLoginHelper
///
/// 외부에서 애플로그인을 간단하게 요청하기 위한 헬퍼
public enum AppleLoginHelper {
  public static func requestAuthorization() async throws -> AppleLoginResult? {
    let window = await MainActor.run { UIApplication.shared.currentWindow }
    return try await AppleLoginManager().performAppleLogin(
      scope: [.fullName, .email],
      window: window
    )
  }
}
