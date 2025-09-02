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
  case login
  case forceAppUpdate(URL)
  case optionalAppUpdate(URL)
  
  var title: String {
    switch self {
    case .sample: "sample title"
    case .locationPermission: "위치접근 동의가 필요합니다"
    case .logout: "정말 로그아웃할까요?"
    case .withdrawal: "정말 탈퇴할까요?"
    case .login: "로그인이\n필요한 기능입니다"
    case .forceAppUpdate: "최신 버전 앱을 이용해주세요"
    case .optionalAppUpdate: "새로운 버전이 출시되었습니다"
    }
  }
  
  var message: String? {
    switch self {
    case .sample: "sample message.\nThis is a sample message for the alert type."
    case .locationPermission: "현재 위치 접근에 대한 권한 동의가 거부되었습니다. ‘설정 > 개인정보 보호'에서 위치 접근을 허용해주세요."
    case .withdrawal: "탈퇴하면 되돌릴 수 없어요."
    case .forceAppUpdate: "보다 안정적인 서비스 제공을 위해 앱을\n최신 버전으로 업데이트 해야 합니다"
    case .optionalAppUpdate: "앱을 업데이트 하여 새로운 기능을 만나보세요."
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
    case .forceAppUpdate, .optionalAppUpdate: return "닫기"
    default: return "취소"
    }
  }
  
  var accept: String {
    switch self {
    case .sample: "sample"
    case .locationPermission: "설정으로 이동"
    case .logout: "로그아웃"
    case .withdrawal: "탈퇴하기"
    case .login: "로그인하러 가기"
    case .forceAppUpdate, .optionalAppUpdate: "업데이트하러 가기"
    }
  }
  
  public var isSingleButton: Bool {
    switch self {
    case .forceAppUpdate: return true
    default: return false
    }
  }
}

public enum AlertResult {
  case close, accept
}
