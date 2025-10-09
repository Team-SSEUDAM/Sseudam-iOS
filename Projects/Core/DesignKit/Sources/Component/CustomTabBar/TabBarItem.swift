//
//  TabBarItem.swift
//  DesignKit
//
//  Created by 조용인 on 6/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum TabBarItem: String, CaseIterable, Identifiable {
  case home
  case myPet
  case notification
  case myPage
  
  public var id: String { rawValue }
  
  /// 이미지
  public var tabBarIcons: (selected: ImageSet, unselected: ImageSet) {
    switch self {
    case .home: return (.homeFilled, .home)
    case .myPet: return (.interestsFilled, .interests)
    case .notification: return (.notificationFilled, .notification)
    case .myPage: return (.personFilled, .person)
    }
  }
  
  /// 탭바 아래에 표시할 텍스트
  public var title: String {
    switch self {
    case .home: return "홈"
    case .myPet: return "마이펫"
    case .notification: return "알림"
    case .myPage: return "마이페이지"
    }
  }
}
