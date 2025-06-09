//
//  MapViewRepresentable.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import UIKit
import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  
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
    
//    moveCamera(view, to: defaultPoint)
    return view
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    
  }
  
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  
}


extension MapViewRepresentable {
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    var parent: MapViewRepresentable
    
    init(_ parent: MapViewRepresentable) {
      self.parent = parent
    }
  }
}

