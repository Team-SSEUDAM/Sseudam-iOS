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

@Reducer
public struct MixPanelFeature {
  @ObservableState public struct State: Equatable {
    public init() {
      
    }
  }
  
  public enum Action {
    case track(AppEvent)
    case setOptIn(Bool)
    case registerSuper([String: Any], once: Bool = false)
    case setUserProps([String: Any])
  }
  
  @Dependency(\.analytics) var analytics
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .track(let ev):
        switch ev {
          /// - deprecated: 이전 이벤트 (2024-09-03)
        case let .appViewedSplash(session_id, ts, ctx):
          analytics.track(.앱_기본_플로우_이벤트(.앱_시작_화면_진입),
                          base(ctx).merging([
                            "session_id": session_id,
                            "timestamp": ts.toISOString()
                          ]))
          
          /// 세션 시작, 메인화면 [1.1. Map] 진입
        case let .sessionStarted(duration, gap, ctx):
          analytics.track(.앱_기본_플로우_이벤트(.세션_시작),
                          base(ctx).merging([
                            "session_duration": duration as Any,
                            "previous_session_gap": gap as Any
                          ]))
          
          ///
        case let .attendanceCompletedNth(streak, ctx):
          analytics.track(.출석_관련_이벤트(.일반_출석_완료),
                          base(ctx).merging(["streak_count": streak]))
          /// - deprecated: 이전 이벤트 (2024-09-03)
        case let .attendanceAchieveStreak(streak, ctx):
          analytics.track(.출석_관련_이벤트(.연속_출석_달성),
                          base(ctx).merging(["streak_count": streak]))
          
          /// - 일반 출석 완료(매 출석 시)
        case let .mapCategoryTapped(category, ctx):
          analytics.track(.지도_및_방문_인증_이벤트(.카테고리_클릭),
                          base(ctx).merging(["category_type": category.rawValue]))
          
        case let .mapPinTapped(trashId, trashType, distance, ctx):
          analytics.track(.지도_및_방문_인증_이벤트(.지도_핀_클릭),
                          base(ctx).merging([
                            "trash_id": trashId,
                            "trash_type": trashType.rawValue,
                            "distance_from_user": distance as Any
                          ]))
          
        case let .visitAuthStarted(acc, trashId, trashType, distance, ctx):
          analytics.track(.지도_및_방문_인증_이벤트(.방문_인증_시작),
                          base(ctx).merging([
                            "gps_accuracy": acc as Any,
                            "trash_id": trashId,
                            "trash_type": trashType.rawValue,
                            "distance_from_user": distance as Any
                          ]))
          
        case let .visitAuthCompleted(trashId, trashType, distance, ctx):
          analytics.track(.지도_및_방문_인증_이벤트(.방문_인증_완료),
                          base(ctx).merging([
                            "trash_id": trashId,
                            "trash_type": trashType.rawValue,
                            "distance_from_user": distance as Any
                          ]))
          
          // 4) 제보
        case let .suggestionStartNew(ctx):
          analytics.track(.제보_관련_이벤트(.새_제보_시작), base(ctx))
          
        case let .suggestionClickLocation(ctx):
          analytics.track(.제보_관련_이벤트(.제보_위치_지도_영역_클릭), base(ctx))
          
        case let .suggestionSetLocation(ctx):
          analytics.track(.제보_관련_이벤트(.제보_위치_설정_완료), base(ctx))
          
        case let .suggestionInputName(len, ctx):
          analytics.track(.제보_관련_이벤트(.제보_정보_입력_완료),
                          base(ctx).merging(["description_length": len]))
          
        case let .suggestionSelectCategory(trashType, ctx):
          analytics.track(.제보_관련_이벤트(.쓰레기통_유형_선택_완료),
                          base(ctx).merging(["trash_type": trashType.rawValue]))
          
        case let .suggestionUploadPhoto(fileSize, photoType, ctx):
          analytics.track(.제보_관련_이벤트(.사진_업로드_완료),
                          base(ctx).merging([
                            "file_size": fileSize as Any,
                            "photo_type": photoType.rawValue
                          ]))
          
        case let .suggestionCompleteSubmission(submissionId, ctx):
          analytics.track(.제보_관련_이벤트(.제보_제출_완료),
                          base(ctx).merging(["submission_id": submissionId]))
          
          // 5) 신고
        case let .reportStartNew(ctx):
          analytics.track(.신고_관련_이벤트(.새_신고_시작), base(ctx))
          
        case let .reportSetLocation(selected, ctx):
          analytics.track(.신고_관련_이벤트(.정보_유형_선택),
                          base(ctx).merging(["report_info_types": selected.map(\.rawValue)]))
          
        case let .reportCompleteSubmission(ctx):
          analytics.track(.신고_관련_이벤트(.신고_제출_완료), base(ctx))
          
          // 식별
        case let .identify(userId): analytics.identify(userId)
        case let .alias(userId):    analytics.alias(userId)
        }
        return .none
        
      case let .setOptIn(enabled):
        analytics.setTracking(enabled); return .none
        
      case let .registerSuper(props, once):
        analytics.registerSuperProperties(props, once); return .none
        
      case let .setUserProps(props):
        analytics.setUserProperties(props); return .none
      }
    }
  }
}

// MARK: - Prop 헬퍼
private func base(_ ctx: UserCtx?) -> [String: Any] {
  guard let ctx else { return [:].compact() }
  return [
    "user_id": ctx.user_id as Any,
    "user_location": ctx.user_location as Any,
    "user_level": ctx.user_level as Any,
  ].compact()
}

private extension Dictionary where Key == String, Value == Any {
  func merging(_ more: [String: Any]) -> [String: Any] {
    self.merging(more, uniquingKeysWith: { _, new in new }).compact()
  }
  func compact() -> [String: Any] {
    filter { !($0.value is OptionalProtocol && ( $0.value as? OptionalProtocol )!.isNil ) }
  }
}

// Optional 제거용 얇은 프로토콜
private protocol OptionalProtocol { var isNil: Bool { get } }
extension Optional: OptionalProtocol { var isNil: Bool { self == nil } }
