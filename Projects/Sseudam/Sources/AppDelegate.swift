//
//  AppDelegate.swift
//  Sseudam
//
//  Created by 조용인 on 10/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Dependencies
import FirebaseCore
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // MARK: - Firebase 초기 설정
    FirebaseConfiguration.shared.setLoggerLevel(.min) /// Firebase 로그 최소화
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().delegate = self
    UIApplication.shared.registerForRemoteNotifications()
    return true
  }
  
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    return true
  }
  
  
  // MARK: UISceneSession Lifecycle
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    configuration.delegateClass = SceneDelegate.self
    return configuration
  }
  
  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
  
  //MARK: - APNs 토큰이 갱신되었을 때 호출
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("✅ APNs token: \(tokenString)")
  }
  
  //MARK: - FCM 토큰이 갱신되었을 때 호출
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔔 Firebase registration token: \(String(describing: fcmToken))")
  }
  
  //MARK: - 포그라운드에서 알림 수신 시 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification
  ) async -> UNNotificationPresentationOptions {
    return [.banner, .sound, .badge]
  }
  
  //MARK: - 배너를 눌렀을 때 처리
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse
  ) async {
    // 알림의 userInfo에서 처리할 데이터 수신
    let userInfo = response.notification.request.content.userInfo
    
    //TODO: - 전달받은 UserInfo 처리
    @Dependency(\.deepLinkClient) var deepLinkClient
    
    //MARK: - (임시)userInfo에서 `action` 키로 경로를 받아 딥링크 처리
    /// (optional) 나중에는, 이동해야하는 `경로에 따라 id 값들을 추가로 받아야 할 수` 있기 때문에 `DeepLink관련 Struct를 만들어 처리`하는 것을 고려
    if let path = userInfo["path"] as? String {
      deepLinkClient.handle(path)
      print("🔔 Push Banner 탭: \(path)")
    }
  }
  
}
