//
//  AnalyticsClient+.swift
//  AnalyticsKit
//
//  Created by 조용인 on 9/3/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Mixpanel
#if canImport(UIKit)
import UIKit
#endif

public struct MixpanelConfig: Sendable {
  public var token: String
  public var serverURL: String?
  public var trackAutomaticEvents: Bool
  public var optOutTrackingByDefault: Bool
  /// 앱 공통 Super Properties를 추가로 얹고 싶을 때 사용
  public var additionalSuperProperties: @Sendable () -> Properties
  
  public init(
    token: String,
    serverURL: String? = nil,
    trackAutomaticEvents: Bool = false,
    optOutTrackingByDefault: Bool = false,
    additionalSuperProperties: @escaping @Sendable () -> Properties = { [:] }
  ) {
    self.token = token
    self.serverURL = serverURL
    self.trackAutomaticEvents = trackAutomaticEvents
    self.optOutTrackingByDefault = optOutTrackingByDefault
    self.additionalSuperProperties = additionalSuperProperties
  }
}

public extension AnalyticsClient {
  
  /// Mixpanel 기반 라이브 구현을 생성한다. App 부트스트랩에서 단 한 번 주입해라.
  static func mixpanel(_ config: MixpanelConfig) -> Self {
    // 1) 초기화
    Mixpanel.initialize(
      token: config.token,
      trackAutomaticEvents: config.trackAutomaticEvents,
      serverURL: config.serverURL
    )
    
    let mp = Mixpanel.mainInstance()
    
    // 2) 기본 Super Properties 등록
    var superProps: Properties = [
      "app_version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
      "build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "",
      "platform": "iOS",
      "os_version": {
#if canImport(UIKit)
        UIDevice.current.systemVersion
#else
        "unknown"
#endif
      }(),
    ]
    // 호출 시점에 동적으로 합치기
    superProps.merge(config.additionalSuperProperties(), uniquingKeysWith: { _, new in new })
    mp.registerSuperProperties(superProps)
    
    // 3) 기본 옵트 상태
    config.optOutTrackingByDefault ? mp.optOutTracking() : mp.optInTracking()
    
    // 4) 라이프사이클 훅(백그라운드 시 flush)
    MixpanelLifecycle.shared.activate()
    
    // 5) AnalyticsClient 구현 바인딩
    return AnalyticsClient(
      track: { event, props in
        if let props = props {
          let mpProps = toMPProperties(props)
          mp.track(event: event.eventName, properties: mpProps.isEmpty ? nil : mpProps)
        } else {
          mp.track(event: event.eventName)
        }
      },
      identify: { userId in
        mp.identify(distinctId: userId)
      },
      alias: { userId in
        // 가입 직후 1회만: alias → identify
        let distinct = mp.distinctId
        mp.createAlias(userId, distinctId: distinct)
        mp.identify(distinctId: userId)
      },
      setUserProperties: { properties in
        mp.people.set(properties: toMPProperties(properties))
      },
      registerSuperProperties: { properties, once in
        let mpProps = toMPProperties(properties)
        once ? mp.registerSuperPropertiesOnce(mpProps) : mp.registerSuperProperties(mpProps)
      },
      setTracking: { enabled in
        enabled ? mp.optInTracking() : mp.optOutTracking()
      },
      reset: {
        mp.reset()
      }
    )
  }
  
  /// 편의 생성자
  static func mixpanel(
    token: String,
    trackAutomaticEvents: Bool = false,
    serverURL: String? = nil,
    optOutTrackingByDefault: Bool = false
  ) -> Self {
    .mixpanel(
      MixpanelConfig(
        token: token,
        serverURL: serverURL,
        trackAutomaticEvents: trackAutomaticEvents,
        optOutTrackingByDefault: optOutTrackingByDefault
      )
    )
  }
  
  private static func toMPProperties(_ dict: [String: Any]) -> Properties {
    var result: Properties = [:]
    for (k, v) in dict {
      // 대부분의 원시 타입(String/Int/Double/Bool/Date/NSNull 등)은 MixpanelType 채택
      if let mv = v as? MixpanelType {
        result[k] = mv
      } else if let url = v as? URL {
        result[k] = url.absoluteString as MixpanelType
      } else {
        result[k] = String(describing: v) as MixpanelType
      }
    }
    return result
  }
}

