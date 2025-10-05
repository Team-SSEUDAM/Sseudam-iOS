//
//  DeepLinkClient.swift
//  Sseudam
//
//  Created by 조용인 on 10/5/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import ComposableArchitecture
import Combine

@DependencyClient
public struct DeepLinkClient {
  /// DeepLink path들을 스트림으로 전달
  public var stream: @Sendable () -> AsyncStream<String> = { .finished }
  /// 새로운 DeepLink path를 처리
  public var handle: @Sendable (String) -> Void
}

// MARK: - Live Implementation
extension DeepLinkClient: DependencyKey {
  public static let liveValue: Self = {
    let subject = PassthroughSubject<String, Never>()
    
    return Self(
      stream: {
        AsyncStream { continuation in
          let cancellable = subject.sink { path in
            continuation.yield(path)
          }
          
          continuation.onTermination = { _ in
            cancellable.cancel()
          }
        }
      },
      handle: { path in
        // path 정규화 (선택사항)
        let normalizedPath = path
          .trimmingCharacters(in: .whitespacesAndNewlines)
          .replacingOccurrences(of: "//", with: "/")
        
        print("🔗 DeepLinkClient handling: \(normalizedPath)")
        subject.send(normalizedPath)
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
