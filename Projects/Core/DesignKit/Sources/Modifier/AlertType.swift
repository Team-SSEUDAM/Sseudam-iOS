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
  case logout
  case withdrawal
  
  var title: String {
    switch self {
    case .sample: "sample title"
    case .locationPermission: "위치접근 동의가 필요합니다"
    case .logout: "정말 로그아웃할까요?"
    case .withdrawal: "정말 탈퇴할까요?"
    }
  }
  
  var message: String? {
    switch self {
    case .sample: "sample message.\nThis is a sample message for the alert type."
    case .locationPermission: "현재 위치 접근에 대한 권한 동의가 거부되었습니다. ‘설정 > 개인정보 보호'에서 위치 접근을 허용해주세요."
    case .withdrawal: "탈퇴하면 되돌릴 수 없어요."
    default: .none
    }
  }
  
  public var isErrorType: Bool {
    switch self {
    case .logout, .withdrawal: return true
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
    case .logout: "로그아웃"
    case .withdrawal: "탈퇴하기"
    }
  }
}

public enum AlertResult {
  case close, accept
}
