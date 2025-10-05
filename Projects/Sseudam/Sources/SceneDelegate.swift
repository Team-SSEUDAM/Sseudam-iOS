//
//  SceneDelegate.swift
//  Sseudam
//
//  Created by 조용인 on 10/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Dependencies

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
  
  var window: UIWindow?
  @Dependency(\.deepLinkClient) var deepLinkClient
  
  // MARK: - 앱이 실행될 때(Cold Launch) 호출되는 메서드
  /// 이 메서드는 앱이 처음 실행될 때 호출되며, 앱의 초기 설정이나 화면을 구성하는 데 사용됩니다.
  /// - note:
  ///   - 앱이 백그라운드에서 활성화될 때는 호출되지 않습니다.
  ///   - 이 메서드는 `Universal Links`나 `푸시 알림`을 통해 앱이 실행될 때도 호출됩니다.
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    /// `푸시 알림`으로 앱 시작
    if let notiResponse = connectionOptions.notificationResponse {
      handlePushNotification(
        userInfo: notiResponse.notification.request.content.userInfo,
        isColdLaunch: true
      )
      return
    }
    
    /// `Universal Link`로 앱 시작
    if let userActivity = connectionOptions.userActivities.first,
       userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      handleUniversalLink(url: url, isColdLaunch: true)
    }
  }
  
  // MARK: - 외부 Activity(딥링크, Handoff 등)로 앱이 실행 중일 때 호출되는 메서드
  /// 이 메서드는 `앱이 이미 실행 중이거나 백그라운드 상태(Not running 제외)`일 때,
  /// 외부에서 `NSUserActivity`가 전달되면 호출됩니다.
  /// - note:
  ///   - 앱이 완전히 종료된 상태에서 Activity로 실행되면 `scene(_:willConnectTo:options:)`가 대신 호출됩니다.
  ///   - activityType이 `NSUserActivityTypeBrowsingWeb`인 경우, `웹 URL 기반 딥링크(Universal Link)`로 간주됩니다.
  func scene(
    _ scene: UIScene,
    continue userActivity: NSUserActivity
  ) {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL else { return }
    
    handleUniversalLink(url: url, isColdLaunch: false)
  }
}

// MARK: - `Universal Links`나 `푸시 알림`을 통해 앱이 실행될 때, navigate동작을 처리하기 위한 메서드들
extension SceneDelegate {
  // 🔗 Universal Link 처리
  private func handleUniversalLink(url: URL, isColdLaunch: Bool) {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
    let path = components.path
    deepLinkClient.handle(path)
    print("🔥 Universal Link 전달: \(path)")
  }
  
  // 🔔 푸시 알림 처리
  private func handlePushNotification(userInfo: [AnyHashable: Any], isColdLaunch: Bool) {
    // 푸시 페이로드에서 action 추출
    guard let path = userInfo["action"] as? String else { return }
    deepLinkClient.handle(path)
    print("🔥 Push Notification 전달: \(path)")
  }
}

// MARK: - Scene의 생명주기 메서드 정의
extension SceneDelegate {
  
  // MARK: - 앱이 종료되거나 시스템에 의해 연결이 해제될 때 호출됨
  func sceneDidDisconnect(_ scene: UIScene) { /*리소스 해제나 상태 저장에 활용*/ }
  
  // MARK: - 앱이 활성화되었을 때 호출됨 (사용자와 상호작용 가능한 상태)
  func sceneDidBecomeActive(_ scene: UIScene) { /*일시정지된 작업 재시작 또는 UI 업데이트*/ }
  
  // MARK: - 앱이 비활성화 상태로 전환되기 직전에 호출됨
  func sceneWillResignActive(_ scene: UIScene) { /*전화 수신, 알림 등으로 일시적으로 비활성화될 때*/ }
  
  // MARK: - 백그라운드 → 포그라운드 진입 직전에 호출됨
  func sceneWillEnterForeground(_ scene: UIScene) { /*앱이 다시 보이기 직전에 필요한 초기화 작업*/ }
  
  // MARK: - 앱이 백그라운드로 진입했을 때 호출됨
  func sceneDidEnterBackground(_ scene: UIScene) { /*데이터 저장, 백그라운드 작업 등록 등*/ }
}
