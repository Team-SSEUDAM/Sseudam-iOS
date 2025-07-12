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
  case withdrawal
}

extension SettingType {
  var title: String {
    switch self {
    case .suggestion:
      "쓰레기통 제보하기"
    case .feedback:
      "피드백 남기기"
    case .notification:
      "푸시 알림"
    case .update:
      "최신버전 업데이트"
    case .serviceTerm:
      "서비스 이용약관"
    case .privacyTerm:
      "개인정보처리방침"
    case .logout:
      "로그아웃"
    case .withdrawal:
      "탈퇴하기"
    }
  }
  
  
  var icon: ImageSet? {
    switch self {
    case .suggestion: return ImageSet.addSpot
    case .feedback: return ImageSet.feedback
    case .notification: return ImageSet.notification
    default: return .none
    }
  }
  
}
