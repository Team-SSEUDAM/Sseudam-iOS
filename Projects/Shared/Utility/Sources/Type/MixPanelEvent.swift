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
  case 일반_출석_완료 = "Attendance_Complete_Nth"
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

// MARK: - 공통 컨텍스트 & 보조 타입 (snake_case 키를 유지)
public struct UserCtx: Equatable, Sendable, Encodable {
  public var user_id: Int?        // 게스트면 nil
  public var user_location: String?  // 서울특별시
  public var user_level: Int?        // 레벨
  public init(
    user_id: Int?,
    user_location: String?,
    user_level: Int?
  ) {
    self.user_id = user_id
    self.user_location = user_location
    self.user_level = user_level
  }
}

public enum MPCategoryType: String, Sendable, Codable { case all, general, recycle } // category_type
public enum MPTrashType: String, Sendable, Codable { case general, recycle }         // trash_type
public enum MPPhotoType: String, Sendable, Codable { case camera, gallery }          // photo_type
public enum MPReportInfoField: String, Sendable, CaseIterable, Codable {
  case location, name, category, photo
}

public enum AppEvent: Equatable, Sendable {
  // 1) 앱 기본 플로우
  case appViewedSplash(session_id: String, timestamp: Date, ctx: UserCtx)
  case sessionStarted(session_duration: TimeInterval?, previous_session_gap: TimeInterval?, ctx: UserCtx?)

  // 2) 출석
  case attendanceCompletedNth(streak_count: Int, ctx: UserCtx?)
  case attendanceAchieveStreak(streak_count: Int, ctx: UserCtx?)

  // 3) 지도/방문 인증
  case mapCategoryTapped(category_type: MPCategoryType, ctx: UserCtx?)
  case mapPinTapped(trash_id: String, trash_type: MPTrashType, distance_from_user: Double?, ctx: UserCtx?)
  case visitAuthStarted(gps_accuracy: Double?, trash_id: String, trash_type: MPTrashType, distance_from_user: Double?, ctx: UserCtx?)
  case visitAuthCompleted(trash_id: String, trash_type: MPTrashType, distance_from_user: Double?, ctx: UserCtx?)

  // 4) 제보
  case suggestionStartNew(ctx: UserCtx?)
  case suggestionClickLocation(ctx: UserCtx?)
  case suggestionSetLocation(ctx: UserCtx?)
  case suggestionInputName(description_length: Int, ctx: UserCtx?)
  case suggestionSelectCategory(trash_type: MPTrashType, ctx: UserCtx?)
  case suggestionUploadPhoto(file_size: Int?, photo_type: MPPhotoType, ctx: UserCtx?)
  case suggestionCompleteSubmission(submission_id: String, ctx: UserCtx?)

  // 5) 신고
  case reportStartNew(ctx: UserCtx?)
  case reportSetLocation(selected_info_types: Set<MPReportInfoField>, ctx: UserCtx?)
  case reportCompleteSubmission(ctx: UserCtx?)

  // 식별(선택)
  case identify(userId: String)
  case alias(userId: String)
}
