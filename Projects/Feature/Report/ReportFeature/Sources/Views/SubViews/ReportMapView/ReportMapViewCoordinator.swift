//
//  MapViewCoordinator.swift
//  ReportFeature
//
//  Created by 조용인 on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import NMapsMap
import ReportDomainInterface

extension ReportMapViewRepresentable {
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    var parent: ReportMapViewRepresentable
    private var isMovingByGesture = false
    
    init(_ parent: ReportMapViewRepresentable) {
      self.parent = parent
    }
    
    // ② 지도가 움직이는 동안(드래그/컨트롤) 호출
    func mapView(
      _ mapView: NMFMapView,
      cameraIsChangingByReason reason: Int
    ) {
      if reason == NMFMapChangedByGesture || reason == NMFMapChangedByControl {
        isMovingByGesture = true
      }
    }
    
    // 드래그·줌 후 Idle 상태가 되면 중앙 좌표 콜백
    func mapViewCameraIdle(_ mapView: NMFMapView) {
      guard isMovingByGesture else { return }
      isMovingByGesture = false
      
      let target = mapView.cameraPosition.target
      let center = Coordinates(
        latitude: target.lat.rounded(to: 6),
        longitude: target.lng.rounded(to: 6)
      )
      
      Task { @MainActor in
        parent.onCenterCoordinateChange?(center)
      }
    }
  }
}
