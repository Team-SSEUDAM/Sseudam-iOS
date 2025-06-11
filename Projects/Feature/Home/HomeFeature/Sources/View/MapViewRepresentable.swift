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
    if let userLocation = userLocation {
      moveLocation(uiView, to: userLocation, context: context)
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
}


extension MapViewRepresentable {
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    var parent: MapViewRepresentable
    
    var lastCameraPoint: MapPoint?
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
      // 앱 처음 진입 시 카메라 이동 완료 후 지도 범위 값 가져오도록 처리
//      if isInitialBounds, parent.requestBounds {
//        parent.currentVisibleBounds(on: mapView)
//        parent.requestBounds = false
//        isInitialBounds = false
//      }
    }
  }
}

