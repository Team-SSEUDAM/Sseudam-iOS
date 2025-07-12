//
//  SettingType.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit

/// 각 설정 아이템의 타입
///
/// 리스트 탭 이벤트 시 구분하기 위한 타입으로 사용됨
public enum SettingType {
  case suggestion
  case feedback
  
  case notification
  
  case update
  case serviceTerm
  case privacyTerm
  
  case logout
  case withdraw
}
