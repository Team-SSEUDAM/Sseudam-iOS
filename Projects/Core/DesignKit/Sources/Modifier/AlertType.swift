//
//  AlertType.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum AlertType: Equatable {
  case sample
  case locationPermission
  
  var title: String {
    switch self {
    case .sample: "sample title"
    case .locationPermission: "위치접근 동의가 필요합니다"
    }
  }
  
  var message: String? {
    switch self {
    case .sample: "sample message.\nThis is a sample message for the alert type."
    case .locationPermission: "현재 위치 접근에 대한 권한 동의가 거부되었습니다. ‘설정 > 개인정보 보호'에서 위치 접근을 허용해주세요."
    }
  }
  
  public var isErrorType: Bool {
    switch self {
    default: return false
    }
  }
  
  var cancel: String {
    switch self {
    case .sample: return "cancel"
    default: return "취소"
    }
  }
  
  var accept: String {
    switch self {
    case .sample: "sample"
    case .locationPermission: "설정으로 이동"
    }
  }
}

public enum AlertResult {
  case close, accept
}
