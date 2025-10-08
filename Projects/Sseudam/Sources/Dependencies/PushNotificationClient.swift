//
//  PushNotificationClient.swift
//  Sseudam
//
//  Created by 조용인 on 10/8/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import FirebaseMessaging
import UserNotifications
import UIKit

@DependencyClient
struct PushNotificationClient {
  var checkAuthorizationStatus: @Sendable () async -> UNAuthorizationStatus = { .notDetermined }
  var requestAuthorization: @Sendable () async -> Bool = { false }
  var getFCMToken: @Sendable () async -> String? = { nil }
  var registerForRemoteNotifications: @Sendable () -> Void = {}
  var openSettings: @Sendable () async -> Void = {}
}

extension PushNotificationClient: DependencyKey {
  static let liveValue = Self(
    checkAuthorizationStatus: {
      await UNUserNotificationCenter.current()
        .notificationSettings()
        .authorizationStatus
    },
    requestAuthorization: {
      do {
        let granted = try await UNUserNotificationCenter.current()
          .requestAuthorization(options: [.alert, .badge, .sound])
        
        if granted {
          await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
          }
        }
        
        return granted
      } catch {
        print("❌ 푸시 권한 요청 실패: \(error)")
        return false
      }
    },
    getFCMToken: {
      await withCheckedContinuation { continuation in
        Messaging.messaging().token { token, error in
          continuation.resume(returning: token)
        }
      }
    },
    registerForRemoteNotifications: {
      Task { @MainActor in
        UIApplication.shared.registerForRemoteNotifications()
      }
    },
    openSettings: {
      await UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
  )
}

extension DependencyValues {
  var pushNotificationClient: PushNotificationClient {
    get { self[PushNotificationClient.self] }
    set { self[PushNotificationClient.self] = newValue }
  }
}
