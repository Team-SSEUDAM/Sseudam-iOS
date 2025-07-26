//
//  AttendanceStatus.swift
//  AttendanceFeature
//
//  Created by Jiyeon on 7/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import AttendanceDomainInterface

extension AttendanceStatus {
  var description: String {
    switch self {
    case .first, .success:
      return "쓰담에 접속하면 매일 2쓰담을 드려요.\n5일 연속 출석 시, 5쓰담을 드릴게요!"
    case .fail:
      return "이번엔 놓쳤지만, 괜찮아요.\n다시 도전해봐요!"
    case .continuedSuccess:
      return "감사한 마음을 담아 5쓰담을 드릴게요!\n오늘도"
    }
  }
  
  var title: String {
    switch self {
    case .first: "오늘부터 새 출발!\n첫 출석 완료"
    case let .success(day): "\(day.description)일차"
    case .fail: "아쉽게도 연속 출석 달성에\n실패했어요"
    case .continuedSuccess: "5일차"
    }
  }
}
