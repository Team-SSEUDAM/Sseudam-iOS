//
//  Float+.swift
//  Utility
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public extension Float {
  /// SafeAreaInsets의 bottom 값을 반환합니다.
  public var safeAreaBottom: Self {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first?.windows.first?.safeAreaInsets.bottom ?? 0
  }
  
  public var safeAreaTop: Self {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first?.windows.first?.safeAreaInsets.top ?? 0
  }
}
