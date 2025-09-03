//
//  MixPanelFeature.swift
//  Sseudam
//
//  Created by 조용인 on 9/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import AnalyticsKit
import Utility

public enum AppEvent: Equatable, Sendable {
  // App lifecycle
  case appViewedSplash
  case sessionStarted(sessionId: String)
  
  // Map / Visit
  case mapPinTapped(placeId: String, category: String)
  case mapCategoryTapped(String)
  case visitAuthStarted
  case visitAuthCompleted
  
  // Attendance
  case attendanceFirstCompleted
  case attendanceStreakAchieved(days: Int)
  
  // Suggestion
  case suggestionSubmitted(id: String)
  case suggestionPhotoUploaded(count: Int)
  
  // Report
  case reportSubmitted(id: String)
  
  // Auth (원하면 식별/병합까지 여기서 다룸)
  case identify(userId: String)
  case alias(userId: String)
}


@Reducer
public struct MixPanelFeature {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action {
    case track(AppEvent)
    case setOptIn(Bool)            // 설정 화면 등에서 추적 토글
    case registerSuper([String: Any], once: Bool = false) // 필요시 상위에서 공통 속성 주입
    case setUserProps([String: Any]) // People 속성 업데이트
  }
  
  @Dependency(\.analytics) var analytics
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        
      case .track(let event):
        switch event {
          // App lifecycle
        case .appViewedSplash:
          analytics.track(.앱_기본_플로우_이벤트(.앱_시작_화면_진입), [:])
          
        case let .sessionStarted(sessionId):
          analytics.track(.앱_기본_플로우_이벤트(.세션_시작), ["session_id": sessionId])
          
          // Map / Visit
        case let .mapPinTapped(placeId, category):
          analytics.track(.지도_및_방문_인증_이벤트(.지도_핀_클릭),
                          ["place_id": placeId, "category": category])
          
        case let .mapCategoryTapped(category):
          analytics.track(.지도_및_방문_인증_이벤트(.카테고리_클릭),
                          ["category": category])
          
        case .visitAuthStarted:
          analytics.track(.지도_및_방문_인증_이벤트(.방문_인증_시작), [:])
          
        case .visitAuthCompleted:
          analytics.track(.지도_및_방문_인증_이벤트(.방문_인증_완료), [:])
          
          // Attendance
        case .attendanceFirstCompleted:
          analytics.track(.출석_관련_이벤트(.첫_출석_완료), [:])
          
        case let .attendanceStreakAchieved(days):
          analytics.track(.출석_관련_이벤트(.연속_출석_달성), ["days": days])
          
          // Suggestion
        case let .suggestionSubmitted(id):
          analytics.track(.제보_관련_이벤트(.제보_제출_완료), ["suggestion_id": id])
          
        case let .suggestionPhotoUploaded(count):
          analytics.track(.제보_관련_이벤트(.사진_업로드_완료), ["count": count])
          
          // Report
        case let .reportSubmitted(id):
          analytics.track(.신고_관련_이벤트(.신고_제출_완료), ["report_id": id])
          
          // Auth
        case let .identify(userId):
          analytics.identify(userId)
          
        case let .alias(userId):
          analytics.alias(userId)
        }
        return .none
        
      case let .setOptIn(enabled):
        analytics.setTracking(enabled)
        return .none
        
      case let .registerSuper(props, once):
        analytics.registerSuperProperties(props, once)
        return .none
        
      case let .setUserProps(props):
        analytics.setUserProperties(props)
        return .none
      }
    }
  }
}

