//
//  MapViewCoordinator.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NMapsMap
import HomeDomainInterface

extension MapViewRepresentable {
  class Coordinator: NSObject, NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    var parent: MapViewRepresentable
    
    var lastCameraPoint: MapPoint?
    
    var isInitialBounds: Bool = true
    
    var trashItems: [TrashItem] = []
    
    var markers: [NMFMarker] = []
    
    var activeMarker: NMFMarker?
    var activeData: TrashItem?
    
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
    
    func drawMarker(items: [TrashItem], markers: [NMFMarker]) {
      print("마커 저장하기: \(markers.count)")
      self.trashItems = items
      self.markers = markers
    }
    
    /// 지도에 올라와있는 마커 삭제
    func deleteAllMarkers() {
      print(#function)
      print(markers.count)
      if !markers.isEmpty {
        markers.forEach {
          $0.mapView = nil
        }
        self.markers.removeAll()
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
