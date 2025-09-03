//
//  MixPanelEvent.swift
//  Utility
//
//  Created by 조용인 on 8/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

protocol MixPanelType {
  var eventName: String { get }
}

public enum MixPanelEvent {
  case 앱_기본_플로우_이벤트(앱_기본_플로우)
  case 출석_관련_이벤트(출석_관련)
  case 지도_및_방문_인증_이벤트(지도_및_버리기_인증)
  case 제보_관련_이벤트(제보_관련)
  case 신고_관련_이벤트(신고_관련)
}

public enum 앱_기본_플로우: String, Sendable {
  case 앱_시작_화면_진입 = "App_View_Splash"
  case 세션_시작 = "Session_Start"
}

public enum 출석_관련: String, Sendable {
  case 첫_출석_완료 = "Attendance_Complete_First"
  case 연속_출석_달성 = "Attendance_Achieve_Streak"
}

public enum 지도_및_버리기_인증: String, Sendable {
  case 카테고리_클릭 = "Map_Click_Category"
  case 지도_핀_클릭 = "Map_Click_Pin"
  case 방문_인증_시작 = "Visit_Start_Authentication"
  case 방문_인증_완료 = "Visit_Complete_Authentication"
}

public enum 제보_관련: String, Sendable {
  case 새_제보_시작 = "Suggestion_Start_New"
  case 제보_위치_지도_영역_클릭 = "Suggestion_Click_Location"
  case 제보_위치_설정_완료 = "Suggestion_Set_Location"
  case 제보_정보_입력_완료 = "Suggestion_Input_Name"
  case 쓰레기통_유형_선택_완료 = "Suggestion_Select_Category"
  case 사진_업로드_완료 = "Suggestion_Upload_Photo"
  case 제보_제출_완료 = "Suggestion_Complete_Submission"
}

public enum 신고_관련: String, Sendable {
  case 새_신고_시작 = "Report_Start_New"
  case 정보_유형_선택 = "Report_Set_Location"
  case 신고_제출_완료 = "Report_Complete_Submission"
}

extension MixPanelEvent: MixPanelType {
  public var eventName: String {
    switch self {
    case let .앱_기본_플로우_이벤트(e): return e.rawValue
    case let .출석_관련_이벤트(e):      return e.rawValue
    case let .지도_및_방문_인증_이벤트(e): return e.rawValue
    case let .제보_관련_이벤트(e):      return e.rawValue
    case let .신고_관련_이벤트(e):      return e.rawValue
    }
  }
}
