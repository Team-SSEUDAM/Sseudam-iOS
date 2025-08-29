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
  case 앱_기본_플로우_이벤트(AppBasicFlowEvent)
  case 출석_관련_이벤트(AttandanceEvent)
  case 지도_및_방문_인증_이벤트(MapAndVisitEvent)
  case 제보_관련_이벤트(SuggestionEvent)
  case 알람_및_피드백_이벤트(AlarmAndFeedbackEvent)
  case 펫_및_게임화_이벤트(PetAndGamificationEvent)
}

public enum AppBasicFlowEvent: String, Sendable {
  case 앱_시작_화면_진입 = "App_View_Splash"
  case 위치_권환_및_초기_설정_완료 = "Auth_Complete_LocationSetup"
  case 세션_시작 = "Session_Start"
}

public enum AttandanceEvent: String, Sendable {
  case 첫_출석_완료 = "Attendance_Complete_First"
  case Attendance_Complete_Nth = "Gamification_Attendance_Reward"
  case 연속_출석_달성 = "Attendance_Achieve_Streak"
}

public enum MapAndVisitEvent: String, Sendable {
  case 메인_지도_화면_진입 = "Map_View_MapTab"
  case 지도_핀_클릭 = "Map_Click_Pin"
  case 방문_인증_시작 = "Visit_Start_Authentication"
  case 방문_인증_완료 = "Visit_Complete_Authentication"
}

public enum SuggestionEvent: String, Sendable {
  case 새_제보_시작 = "Report_Start_New"
  case 제보_위치_설정_완료 = "Report_Set_Location"
  case 제보_정보_입력_완료 = "Report_Input_Name"
  case 사진_업로드_완료 = "Report_Upload_Photo"
  case 제보_제출_완료 = "Report_Complete_Submission"
}

public enum AlarmAndFeedbackEvent: String, Sendable {
  case 제보_승인_알림_확인 = "Notification_View_ReportApproved"
  case 쓰레기_처리_알림_확인 = "Notification_View_TrashDisposed"
  case 레벨업_알림_확인 = "Notification_View_LevelUp"
}

public enum PetAndGamificationEvent: String, Sendable {
  case 펫_메인_화면_진입 = "Pet_View_Main"
  case 펫_상세_정보_확인 = "Pet_View_Details"
  case 펫_먹이주기 = "Pet_Action_Feed"
}
