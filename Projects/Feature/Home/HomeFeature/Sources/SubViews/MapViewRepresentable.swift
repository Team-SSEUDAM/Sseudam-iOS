//
//  MapViewRepresentable.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import UIKit
import HomeDomainInterface

import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  
  @Binding var userLocation: MapPoint?
  /// 현재 지도 범위 요청 플래그
  @Binding var requestMapBounds: Bool
  
  /// 지도 범위 전달 클로저
  var mapBounds: (([MapPoint]) -> Void)? = nil
  /// 초기 위치
  private let defaultPoint: MapPoint = .init(latitude: 37.50545, longitude: 127.10143)
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.zoomLevel = 16
    view.mapView.minZoomLevel = 9
    view.mapView.maxZoomLevel = 20
    view.mapView.isIndoorMapEnabled = false
    view.showIndoorLevelPicker = false
    view.mapView.liteModeEnabled = false
    view.mapView.isTiltGestureEnabled = false
    view.mapView.touchDelegate = context.coordinator
    view.mapView.addCameraDelegate(delegate: context.coordinator)
    view.mapView.symbolScale = 0.8
    
    moveCamera(view, to: defaultPoint)
    return view
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    // 사용자 현위치 이동
    if let userLocation = userLocation {
      moveLocation(uiView, to: userLocation, context: context)
    }
    
    // 지도 범위 요청
    if requestMapBounds {
      
    }
    
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  /// 카메라 이동 메서드
  private func moveCamera(_ view: NMFNaverMapView, to point: MapPoint?, zoomLevel: Double = 14) {
    if let point = point {
      let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: zoomLevel)
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
      
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  private func moveLocation(_ view: NMFNaverMapView, to location: MapPoint, context: Context) {
    let cameraPosition = view.mapView.cameraPosition.target
    let point = MapPoint(latitude: cameraPosition.lat, longitude: cameraPosition.lng)
    
    if point != context.coordinator.lastCameraPoint {
      moveCamera(view, to: location)
      context.coordinator.lastCameraPoint = location
    }
    Task {
      await MainActor.run {
        self.userLocation = nil
      }
    }
    
  }
  
  /// 현재 지도에 보이는 좌표 범위를 반환하는 메서드
  func currentVisibleBounds(on mapView: NMFMapView) {
    let bounds = mapView.projection.latlngBounds(fromViewBounds: mapView.bounds)
    let northEast = MapPoint(
      latitude: bounds.northEastLat.rounded(to: 6),
      longitude: bounds.northEastLng.rounded(to: 6)
    )
    let southWest = MapPoint(
      latitude: bounds.southWestLat.rounded(to: 6),
      longitude: bounds.southWestLng.rounded(to: 6)
    )
    if let mapBounds = mapBounds {
      mapBounds([southWest, northEast])
    }
  }
}



extension MapViewRepresentable {
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    var parent: MapViewRepresentable
    
    var lastCameraPoint: MapPoint?
    
    var isInitialBounds: Bool = true
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
      // 앱 처음 진입 시 카메라 이동 완료 후 지도 범위 값 가져오도록 처리
      if isInitialBounds, parent.requestMapBounds {
        parent.currentVisibleBounds(on: mapView)
        parent.requestMapBounds = false
        isInitialBounds = false
      }
    }
  }
}


public extension Double {
  /// 지정한 소수점 자리수까지 반올림
  ///
  /// - Parameters: places: 반올림 할 소수점 자리수
  func rounded(to places: Int) -> Double {
    let multiplier = pow(10.0, Double(places))
    return (self * multiplier).rounded() / multiplier
  }
}
