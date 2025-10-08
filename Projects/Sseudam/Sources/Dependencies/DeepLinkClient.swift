//
//  DeepLinkClient.swift
//  Sseudam
//
//  Created by 조용인 on 10/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Combine
import Foundation

@DependencyClient
public struct DeepLinkClient: Sendable {
  /// DeepLink path들을 스트림으로 전달
  public var stream: @Sendable () -> AsyncStream<String> = { .finished }
  /// 새로운 DeepLink path를 처리
  public var handle: @Sendable (String) -> Void = { _ in }
}

// MARK: - Live Implementation
extension DeepLinkClient: DependencyKey {
  
  public static let liveValue: Self = {
    let subject = PassthroughSubject<String, Never>()
    let pendingPaths = LockIsolated<[String]>([])
    let hasSubscriber = LockIsolated<Bool>(false)
    
    return Self(
      stream: {
        AsyncStream { continuation in
          /// 1. 구독 시작과 동시에, 이후 `handle()`에서 pending 건너뛰도록 설정
          hasSubscriber.setValue(true)
          
          /// 2. 우선 `pendingPaths`를 확인해서, 기존에 `쌓여있던 path`가 있으면 가져오기
          let pending = pendingPaths.value
          /// 3. 이후 `pendingPaths` 초기화 (중복 방지)
          pendingPaths.setValue([])
          
          /// 4-1. 기존에 `쌓여있던 path`들 먼저 전달 (`Cold Launch` 케이스)
          for path in pending {
            continuation.yield(path)
          }
          
          /// 4-2. 이후부터는 `subject`를 통해 실시간으로 path 전달 (`Live` 케이스)
          let cancellable = subject.sink { path in
            continuation.yield(path)
          }
          
          /// 5. 구독 종료 시 처리
          continuation.onTermination = { @Sendable _ in
            hasSubscriber.setValue(false) /// 다시 pending 모드로 전환
            cancellable.cancel()
          }
        }
      },
      handle: { path in
        // 넘어오는 path 일단 그대로 전달 (나중에는 Struct로 파싱해서 전달 필요도 있음)
        print("DeepLinkClient handle을 통해 전달받은 path: \(path)")
        // 현재 구독자가 있으면 바로 전달, 없으면 pending에 저장 (즉, cold start 지원)
        if hasSubscriber.value == true { subject.send(path) }
        else { pendingPaths.withValue {$0.append(path)}
        }
      }
    )
  }()
  
  // MARK: - Test Implementation
  public static let testValue = Self(
    stream: {
      AsyncStream { continuation in
        // 테스트에서 필요한 path들을 여기서 직접 생성
        continuation.finish()
      }
    },
    handle: { path in
      print("📝 Test DeepLinkClient received: \(path)")
    }
  )
  
  // MARK: - Preview Implementation
  public static let previewValue = Self(
    stream: { .finished },
    handle: { _ in }
  )
}

// MARK: - Dependency Registration
extension DependencyValues {
  public var deepLinkClient: DeepLinkClient {
    get { self[DeepLinkClient.self] }
    set { self[DeepLinkClient.self] = newValue }
  }
}
