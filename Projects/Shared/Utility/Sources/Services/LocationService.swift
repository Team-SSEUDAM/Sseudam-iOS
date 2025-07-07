//
//  LocationService.swift
//  Utility
//
//  Created by Jiyeon on 6/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import UIKit
import CoreLocation

public enum LocationUpdateMode {
  case single     // 한 번만 받고 중지
  case continuous // 계속 위치 업데이트
}

/// 위치 권한 관련 서비스 구현
@MainActor
public class LocationService: NSObject, CLLocationManagerDelegate {
  
  public static let shared = LocationService()
  public private(set) var userLocation: Coordinates? = nil
  private let throttleInterval: TimeInterval = 1 // 1초 간격
  private var lastUpdateTime: Date? = nil
  private var mode: LocationUpdateMode = .single

  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  
  /// 단발 위치 요청 시 응답을 위한 continuation
  private var singleLocationContinuation: CheckedContinuation<Coordinates?, Never>?
  
  /// 내부에서 유지하는 위치 업데이트 스트림
  private let userLocationStreamInternal: AsyncStream<Void>
  
  /// 위치 업데이트 발생 시 외부로 전달할 continuation
  private var userLocationContinuation: AsyncStream<Void>.Continuation?
  
  /// 외부에 노출되는 위치 업데이트 스트림 (읽기 전용)
  public var userLocationStream: AsyncStream<Void> {
    userLocationStreamInternal
  }
  
  // MARK: - Initialize
  
  private override init() {
    var continuation: AsyncStream<Void>.Continuation!
    self.userLocationStreamInternal = AsyncStream { cont in
      continuation = cont
    }
    self.userLocationContinuation = continuation
    super.init()
  }
  
  // MARK: - Location Method
  
  
  /// 단발 위치 요청 (버튼 눌렀을 때 사용)
  public func requestSingleLocation() async -> Coordinates? {
    self.mode = .single
    return await withCheckedContinuation { continuation in
      self.singleLocationContinuation = continuation

      let status = locationManager.authorizationStatus
      switch status {
      case .authorizedWhenInUse, .authorizedAlways:
        locationManager.startUpdatingLocation()
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .denied, .restricted:
        self.singleLocationContinuation = nil
        continuation.resume(returning: nil)
      default:
        break
      }
    }
  }
  
  /// 연속으로 유저 위치 요청
  public func startTracking() {
    self.mode = .continuous
    let status = locationManager.authorizationStatus
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      userLocation = nil
      userLocationContinuation?.yield(())
    default:
      break
    }
  }
  
  private func setUserLocation(_ coord: Coordinates?) {
    let now = Date()
    // 1초 throttle
    if let last = lastUpdateTime, now.timeIntervalSince(last) < throttleInterval {
      return
    }
    lastUpdateTime = now
    
    if let coord = coord {
      if coord == userLocation { return }
      else { userLocation = coord }
    } else {
      userLocation = nil
    }
    userLocationContinuation?.yield(())
    
    if let continuation = singleLocationContinuation {
      singleLocationContinuation = nil
      continuation.resume(returning: coord)
    }
    
    if mode == .single {
      locationManager.stopUpdatingLocation()
    }
  }
  
  public func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  // MARK: - Delegate
  
  nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else {
      Task { await setUserLocation(nil) } // 위치 정보 실패 시 nil 전달
      return
    }
    Task {
      await setUserLocation(
        .init(
          latitude: location.coordinate.latitude,
          longitude: location.coordinate.longitude
        )
      )
    }
  }
  
  nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    Task {
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
        await locationManager.startUpdatingLocation()
      case .denied, .restricted:
        await self.setUserLocation(nil)
      default: break
      }
    }
  }
}

