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

struct ReportMapViewRepresentable: UIViewRepresentable {
  @Binding var userLocation: ReportMapPoint?
  
  var onCenterCoordinateChange: (@Sendable (ReportMapPoint) -> Void)? = nil
  
  private let defaultPoint = ReportMapPoint(latitude: 37.50545, longitude: 127.10143)
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    let mapView = NMFNaverMapView()
    mapView.mapView.addCameraDelegate(delegate: context.coordinator)
    moveCamera(mapView, to: defaultPoint)
    return mapView
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
    to point: ReportMapPoint,
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
    _ onCenterCoordinateChange: @escaping @Sendable (ReportMapPoint) -> Void
  ) -> Self {
    var map = self
    map.onCenterCoordinateChange = onCenterCoordinateChange
    return map
  }
}
