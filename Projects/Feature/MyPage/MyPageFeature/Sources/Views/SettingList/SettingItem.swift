//
//  SettingItem.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit

/// 설정 리스트에 들어가는 아이템 타입
public struct SettingItem: Hashable {
  public let type: SettingType
  public let title: String
  public let subtitle: String?
  public let trailing: String?
  public let icon: ImageSet?
  
  public init(
    type: SettingType,
    title: String,
    subtitle: String? = nil,
    trailing: String? = nil,
    icon: ImageSet? = nil
  ) {
    self.type = type
    self.title = title
    self.subtitle = subtitle
    self.trailing = trailing
    self.icon = icon
  }
}
