//
//  MapViewRepresentable.swift
//  ReportFeature
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import UIKit
import Utility
import NMapsMap
import ReportDomainInterface

struct ReportMapViewRepresentable: UIViewRepresentable {
  @Binding var userLocation: Coordinates?
  
  var onCenterCoordinateChange: (@Sendable (Coordinates) -> Void)? = nil
  var onMapMovingStarted: (() -> Void)? = nil
  
  private let defaultPoint = Coordinates(latitude: 37.50545, longitude: 127.10143)
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.minZoomLevel = 18
    view.mapView.zoomLevel = 19
    view.mapView.maxZoomLevel = 20
    view.mapView.isIndoorMapEnabled = false
    view.showIndoorLevelPicker = false
    view.mapView.liteModeEnabled = true
    view.mapView.isTiltGestureEnabled = false
    view.mapView.touchDelegate = context.coordinator
    view.mapView.addCameraDelegate(delegate: context.coordinator)
    view.mapView.symbolScale = 0.8
    
    moveCamera(view, to: defaultPoint)
    return view
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    if let loc = userLocation {
      moveCamera(uiView, to: loc)
      Task { @MainActor in self.userLocation = nil }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  // 카메라 이동 헬퍼
  private func moveCamera(
    _ view: NMFNaverMapView,
    to point: Coordinates,
    zoomLevel: Double = 16
  ) {
    let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
    let update = NMFCameraUpdate(scrollTo: coord, zoomTo: zoomLevel)
    update.animation = .easeOut
    view.mapView.moveCamera(update)
  }
}

extension ReportMapViewRepresentable {
  func onReceive(
    _ onCenterCoordinateChange: @escaping @Sendable (Coordinates) -> Void
  ) -> Self {
    var map = self
    map.onCenterCoordinateChange = onCenterCoordinateChange
    return map
  }
  
  func onMapMovingStarted(
    _ onMapMovingStarted: @escaping () -> Void
  ) -> Self {
    var map = self
    map.onMapMovingStarted = onMapMovingStarted
    return map
  }
}
