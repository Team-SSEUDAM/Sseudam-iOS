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
public actor LocationService: NSObject, CLLocationManagerDelegate {
  
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
  
  private var userLocationContinuation: AsyncStream<Void>.Continuation?
  public var userLocationStream: AsyncStream<Void> {
    AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.userLocationContinuation = continuation
    }
  }
  
  // MARK: - Initialize
  
  private override init() {
    super.init()
  }
  
  // MARK: - Location Method
  
  public func requestUserLocation(mode: LocationUpdateMode = .single) {
    self.mode = mode
    let authorizationStatus = locationManager.authorizationStatus
    switch authorizationStatus {
    case .authorizedWhenInUse, .authorizedAlways:
      userLocation = nil
      locationManager.startUpdatingLocation()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      userLocation = nil
      userLocationContinuation?.yield(())
    @unknown default:
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
      userLocation = coord
    } else {
      userLocation = nil
    }
    userLocationContinuation?.yield(())
    
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

