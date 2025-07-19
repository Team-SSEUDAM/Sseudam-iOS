//
//  VisitedState.swift
//  TrashDetailFeature
//
//  Created by Jiyeon on 7/13/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit

public enum VisitedState {
  /// 방문 인증 5분 지나지 않음
  case remainTime
  /// 쓰레기통이 멀리(5m 밖)에 있음
  case far
  /// 5m 안 쪽에 있음
  case enableVisit
  
  case unknown
  
  case denyPermission
  
  case auth
  
  case notDetermine
  
  var buttonEnable: Bool {
    self == .enableVisit
  }
  
}
