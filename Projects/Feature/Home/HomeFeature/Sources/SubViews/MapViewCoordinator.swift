//
//  MapViewCoordinator.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
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
    
    
    // MARK: - Delegate
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
      if let onMarkerTapped = parent.onMarkerTapped {
        onMarkerTapped(nil)
        resetActiveMarker()
      }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
      if reason == NMFMapChangedByGesture || reason == NMFMapChangedByControl {
        if !isInitialBounds, !parent.isMapMove {
          parent.isMapMove = true
        }
      }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
      configInitialMove(mapView, requestMapBounds: parent.requestMapBounds)
    }
    
    
    // 앱 처음 진입 시 카메라 이동 완료 후 지도 범위 값 가져오도록 처리
    func configInitialMove(_ mapView: NMFMapView, requestMapBounds: Bool) {
      if isInitialBounds, requestMapBounds {
        parent.currentVisibleBounds(on: mapView)
        parent.requestMapBounds = false
        isInitialBounds = false
      }
    }
    
    /// 마커 활성화 설정
    func markerTapEvent(marker: NMFMarker, data: TrashItem) {
      resetActiveMarker()
      self.activeMarker = marker
      self.activeData = data
    }
    
    /// 활성화 되어있는 마커 해제
    private func resetActiveMarker() {
      if let activeMarker = self.activeMarker,
         let activeData = activeData {
        activeMarker.iconImage = activeData.trashType.inactiveImage
        self.activeMarker = nil
        self.activeData = nil
      }
    }
    
    /// 지도에 나타나는 마커 리스트 저장
    func drawMarker(items: [TrashItem], markers: [NMFMarker]) {
      self.trashItems = items
      self.markers = markers
    }
    
    /// 지도에 올라와있는 마커 삭제
    func deleteAllMarkers() {
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

