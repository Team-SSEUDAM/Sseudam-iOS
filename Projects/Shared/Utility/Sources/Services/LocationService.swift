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
  public private(set) var currentCity: String? = nil
  private let throttleInterval: TimeInterval = 1 // 1초 간격
  private var lastUpdateTime: Date? = nil
  private var lastGeocodedLocation: Coordinates? = nil
  private let geocodingDistanceThreshold: Double = 500 // 500미터 이상 이동시에만 재지오코딩
  private var mode: LocationUpdateMode = .single
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  private lazy var singleLocationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  private lazy var continuousLocationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    return manager
  }()
  
  private lazy var geocoder = CLGeocoder()
  
  /// 단발 위치 요청 시 응답을 위한 continuation
  private var singleLocationContinuation: CheckedContinuation<Coordinates?, Never>?
  
  /// 내부에서 유지하는 위치 업데이트 스트림
  private let userLocationStreamInternal: AsyncStream<Void>
  
  /// 위치 업데이트 발생 시 외부로 전달할 continuation
  private var userLocationContinuation: AsyncStream<Void>.Continuation?
  
  /// 외부에 노출되는 위치 업데이트 스트림 (읽기 전용)
  public var userLocationStream: AsyncStream<Void> {
    AsyncStream { continuation in
      // 새로 구독이 시작될 때마다 저장
      self.userLocationContinuation = continuation
    }
  }
  
  /// 도시 업데이트 발생 시 외부로 전달할 continuation
  private var cityUpdateContinuation: AsyncStream<String?>.Continuation?
  
  /// 외부에 노출되는 도시 업데이트 스트림 (읽기 전용)
  public var cityUpdateStream: AsyncStream<String?> {
    AsyncStream { continuation in
      self.cityUpdateContinuation = continuation
      // 현재 도시가 있다면 즉시 전달
      if let city = self.currentCity {
        continuation.yield(city)
      }
    }
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

      let status = singleLocationManager.authorizationStatus
      switch status {
      case .authorizedWhenInUse, .authorizedAlways:
        singleLocationManager.startUpdatingLocation()
      case .notDetermined:
        singleLocationManager.requestWhenInUseAuthorization()
      case .denied, .restricted:
        self.singleLocationContinuation = nil
        continuation.resume(returning: nil)
      @unknown default:
        self.singleLocationContinuation = nil
        continuation.resume(returning: nil)
      }
    }
  }
  
  /// 연속으로 유저 위치 요청
  public func startTracking() {
    self.mode = .continuous
    let status = continuousLocationManager.authorizationStatus
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      continuousLocationManager.startUpdatingLocation()
    case .notDetermined:
      continuousLocationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      userLocation = nil
      userLocationContinuation?.yield(())
    default:
      break
    }
  }
  
  public func stopTracking() {
    continuousLocationManager.stopUpdatingLocation()
  }
  
  // MARK: - Geocoding
  
  /// 좌표를 도시명으로 변환
  private func reverseGeocode(coordinates: Coordinates) async {
    // 이전 지오코딩 위치와 비교하여 충분히 이동했는지 확인
    if let lastLocation = lastGeocodedLocation {
      let distance = calculateDistance(from: lastLocation, to: coordinates)
      if distance < geocodingDistanceThreshold {
        return // 거리가 threshold 미만이면 지오코딩 스킵
      }
    }
    
    let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    
    do {
      let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko_KR"))
      
      if let placemark = placemarks.first {
        // locality: 도시명 (예: 서울특별시)
        // administrativeArea: 행정구역 (예: 서울특별시)
        // subAdministrativeArea: 하위 행정구역 (예: 강남구)
        
        let city = placemark.locality ?? placemark.administrativeArea
        
        // 도시명이 변경된 경우에만 업데이트
        if city != currentCity {
          self.currentCity = city
          self.cityUpdateContinuation?.yield(city)
        }
        
        self.lastGeocodedLocation = coordinates
      }
    } catch {
      if currentCity != nil {
        self.currentCity = nil
        self.cityUpdateContinuation?.yield(nil)
      }
    }
  }
  
  /// 두 좌표 간 거리 계산 (미터 단위)
  private func calculateDistance(from: Coordinates, to: Coordinates) -> Double {
    let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
    return fromLocation.distance(from: toLocation)
  }
  
  /// 수동으로 현재 위치의 도시명 업데이트
  public func updateCurrentCity() async {
    guard let location = userLocation else { return }
    await reverseGeocode(coordinates: location)
  }
  
  // MARK: - Delegate
  
  nonisolated public func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    
    guard let location = locations.last else {
      return
    }
    let coord = Coordinates(
      latitude: location.coordinate.latitude,
      longitude: location.coordinate.longitude
    )
    
    Task { @MainActor in
      // 받은 좌표를 저장
      if manager === singleLocationManager {
        // 단발 요청 완료 처리
        singleLocationManager.stopUpdatingLocation()
        self.singleLocationContinuation?.resume(returning: coord)
        self.singleLocationContinuation = nil
        
        // 단발 요청에서도 도시명 업데이트
        await reverseGeocode(coordinates: coord)
        
      } else if manager === continuousLocationManager {
        self.userLocation = coord
        // 연속 구독 이벤트 발행
        let now = Date()
        // 1초 throttle
        if let last = lastUpdateTime, now.timeIntervalSince(last) < throttleInterval {
          return
        }
        lastUpdateTime = now
        self.userLocationContinuation?.yield(())
        
        // 연속 업데이트에서 도시명 업데이트 (비동기로 처리)
        Task { await reverseGeocode(coordinates: coord) }
      }
    }
  }
  
  nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    Task { @MainActor in
      if manager === singleLocationManager {
        // 단발 권한 처리
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
          singleLocationManager.startUpdatingLocation()
        default:
          singleLocationContinuation?.resume(returning: nil)
          singleLocationContinuation = nil
        }
      } else if manager === continuousLocationManager {
        // 연속 권한 처리
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
          continuousLocationManager.startUpdatingLocation()
        default:
          self.userLocation = nil
          userLocationContinuation?.yield(())
        }
      }
    }
  }
}

