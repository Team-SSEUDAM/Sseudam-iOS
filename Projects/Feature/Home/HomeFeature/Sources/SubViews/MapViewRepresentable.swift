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
import Utility
import NMapsMap

struct MapViewRepresentable: UIViewRepresentable {
  
  @Binding var userLocation: MapPoint?
  /// 현재 지도 범위 요청 플래그
  @Binding var requestMapBounds: Bool
  /// 지도에 나타나는 쓰레기통 아이템 리스트
  @Binding var trashItems: [TrashItem]
  /// 지도 움직임 여부
  @Binding var isMapMove: Bool
  
  @Binding var isNeedDeleteMarker: Bool
  
  /// 지도 범위 전달 클로저
  var mapBounds: (([MapPoint]) -> Void)? = nil
  /// 마커 탭 시 id값을 전달하기 위한 클로저
  var onMarkerTapped: ((Int?) -> Void)? = nil
  
  var didTapMap:(() -> Void)? = nil
  /// 기본 위치
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
      if context.coordinator.isInitialBounds {
        context.coordinator.configInitialMove(
          uiView.mapView,
          requestMapBounds: requestMapBounds
        )
      } else {
        currentVisibleBounds(on: uiView.mapView)
        requestMapBounds = false
      }
    }
    
    if context.coordinator.trashItems != trashItems {
      deleteDrawMarker(context: context)
      if !trashItems.isEmpty {
        presentMarkers(uiView, items: trashItems, context: context)
      }
    }
    
    if isNeedDeleteMarker,
       context.coordinator.activeMarker != nil {
      context.coordinator.resetActiveMarker()
      isNeedDeleteMarker = false
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

// MARK: - Map Control

extension MapViewRepresentable {
  
  /// 카메라 이동 메서드
  private func moveCamera(_ view: NMFNaverMapView, to point: MapPoint?, zoomLevel: Double = 16) {
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
  
  private func markerTapEvent(to marker: NMFMarker, data: TrashItem, context: Context) {
    if marker == context.coordinator.activeMarker { return }
    marker.iconImage = data.trashType.activePinImage
    context.coordinator.markerTapEvent(marker: marker, data: data)
    if let onMarkerTapped = onMarkerTapped {
      onMarkerTapped(data.id)
    }
  }
  
  /// 여러 마커의 중간지점 찾는 메서드
  private func averageCenter(of points: [MapPoint]) -> MapPoint? {
    guard !points.isEmpty else { return nil }

    let total = points.reduce((lat: 0.0, lon: 0.0)) { result, point in
      (result.lat + point.latitude, result.lon + point.longitude)
    }

    let count = Double(points.count)
    return MapPoint(
      latitude: total.lat / count,
      longitude: total.lon / count
    )
  }
}

// MARK: - Marker

extension MapViewRepresentable {
  
  /// 지도에 마커 보여주기
  private func presentMarkers(_ view: NMFNaverMapView, items: [TrashItem], context: Context) {
    
    if context.coordinator.trashItems != items {
      deleteDrawMarker(context: context)
    }
    // 카메라 이동
    let mid = averageCenter(of: items.map { $0.point })
    moveCamera(view, to: mid, zoomLevel: view.mapView.cameraPosition.zoom)
    
    // 그리기
    let markers: [NMFMarker] = items.map { item in
      let point = NMGLatLng(lat: item.point.latitude, lng: item.point.longitude)
      
      let marker = drawMarker(view, to: point, icon: item.trashType.inactiveImage)
      marker.mapView = view.mapView
      
      marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
        guard let marker = overlay as? NMFMarker else { return true }
        markerTapEvent(to: marker, data: item, context: context)
        moveCamera(view, to: item.point)
        return true
      }
      return marker
    }
    // 저장
    context.coordinator.drawMarker(items: items, markers: markers)
  }
  
  /// 지도에 마커 하나 그리기
  private func drawMarker(
    _ view: NMFNaverMapView,
    to point: NMGLatLng,
    icon: NMFOverlayImage,
    anchor: CGPoint = CGPoint(x: 0.5, y: 1)
  ) -> NMFMarker{
    let marker = NMFMarker(position: point, iconImage: icon)
    marker.isHideCollidedSymbols = true
    marker.anchor = anchor
    marker.iconImage = icon
    marker.mapView = view.mapView
    
    return marker
  }
  
  /// 그려져있는 마커 지우기
  func deleteDrawMarker(context: Context) {
    if !context.coordinator.markers.isEmpty {
      context.coordinator.deleteAllMarkers()
      
    }
  }
}
