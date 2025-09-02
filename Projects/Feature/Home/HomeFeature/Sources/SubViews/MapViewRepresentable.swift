//
//  MapViewRepresentable.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import UIKit
import TrashSpotDomainInterface
import Utility
import NMapsMap
import CoreGraphics

struct MapViewRepresentable: UIViewRepresentable {
  
  @Binding var lastCameraPosition: Coordinates?
  
  @Binding var userLocation: Coordinates?
  /// 현재 지도 범위 요청 플래그
  @Binding var requestMapBounds: Bool
  /// 지도에 나타나는 쓰레기통 아이템 리스트
  @Binding var trashItems: [TrashSpot]
  /// 지도 움직임 여부
  @Binding var isMapMove: Bool
  
  @Binding var isNeedDeleteMarker: Bool
  
  @Binding var isTrashDataFirstLoad: Bool
  
  /// 지도 범위 전달 클로저
  var mapBounds: (([Coordinates]) -> Void)? = nil
  /// 마커 탭 시 id값을 전달하기 위한 클로저
  var onMarkerTapped: ((Int?) -> Void)? = nil
  
  var didTapMap:(() -> Void)? = nil
  /// 기본 위치
  private let defaultPoint: Coordinates = .init(latitude: 37.50545, longitude: 127.10143)
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    let view = NMFNaverMapView()
    view.showZoomControls = false
    view.mapView.positionMode = .direction
    view.mapView.minZoomLevel = 8
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
    if requestMapBounds, !context.coordinator.isInitialBounds {
      currentVisibleBounds(on: uiView.mapView)
      requestMapBounds = false
    }
    
    // 새로운 trash data(nil 포함)
    if context.coordinator.trashItems != trashItems {
      deleteDrawMarker(context: context)
      if !trashItems.isEmpty {
        presentMarkers(uiView, items: trashItems, context: context)
      }
    }
    
    // 활성화 되어있는 마커 지우기
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

// MARK: - Map Event

extension MapViewRepresentable {
  
  private func moveLocation(_ view: NMFNaverMapView, to location: Coordinates, context: Context) {
    let cameraPosition = view.mapView.cameraPosition.target
    let point = Coordinates(latitude: cameraPosition.lat, longitude: cameraPosition.lng)
    
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
    let northEast = Coordinates(
      latitude: bounds.northEastLat.rounded(to: 6),
      longitude: bounds.northEastLng.rounded(to: 6)
    )
    let southWest = Coordinates(
      latitude: bounds.southWestLat.rounded(to: 6),
      longitude: bounds.southWestLng.rounded(to: 6)
    )
    if let mapBounds = mapBounds {
      mapBounds([southWest, northEast])
    }
  }
  
  private func markerTapEvent(to marker: NMFMarker, data: TrashSpot, context: Context) {
    if marker == context.coordinator.activeMarker { return }
    marker.iconImage = data.trashType.activePinImage
    context.coordinator.markerTapEvent(marker: marker, data: data)
    if let onMarkerTapped = onMarkerTapped {
      onMarkerTapped(data.id)
    }
  }
  
  /// 여러 마커의 중간지점 찾는 메서드
  private func averageCenter(of points: [Coordinates]) -> Coordinates? {
    guard !points.isEmpty else { return nil }
    
    let total = points.reduce((lat: 0.0, lon: 0.0)) { result, point in
      (result.lat + point.latitude, result.lon + point.longitude)
    }
    
    let count = Double(points.count)
    return Coordinates(
      latitude: total.lat / count,
      longitude: total.lon / count
    )
  }
}

// MARK: - Marker

extension MapViewRepresentable {
  
  /// 지도에 마커 보여주기
  private func presentMarkers(_ view: NMFNaverMapView, items: [TrashSpot], context: Context) {
    print(#function, items.count)
    if context.coordinator.trashItems != items {
      deleteDrawMarker(context: context)
    }
    
    // 카메라 이동
    moveCameraForShowMarker(view, items: items, context: context)
    
    // 그리기
    let markers: [NMFMarker] = items.map { item in
      let point = NMGLatLng(lat: item.location.latitude, lng: item.location.longitude)
      
      let marker = drawMarker(view, to: point, icon: item.trashType.inactiveImage)
      marker.mapView = view.mapView
      
      marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
        guard let marker = overlay as? NMFMarker else { return true }
        markerTapEvent(to: marker, data: item, context: context)
        moveCamera(view, to: item.location)
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

// MARK: - 카메라 이동

extension MapViewRepresentable {
  
  /// 카메라 이동 메서드
  private func moveCamera(_ view: NMFNaverMapView, to point: Coordinates?, zoomLevel: Double = 20) {
    if let point = point {
      let coord = NMGLatLng(lat: point.latitude, lng: point.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: coord, zoomTo: zoomLevel)
      cameraUpdate.animation = .easeOut
      cameraUpdate.animationDuration = 1
      
      view.mapView.moveCamera(cameraUpdate)
    }
  }
  
  /// 마커 보여줄 때 조건에 따라 카메라 이동 조절
  private func moveCameraForShowMarker(
    _ view: NMFNaverMapView,
    items: [TrashSpot],
    context: Context
  ) {
    // 카메라 이동
    if !items.isEmpty  {
      if isTrashDataFirstLoad {
        if items.count >= 20 {
          let currentPosition = view.mapView.cameraPosition.target
          let mapPoint: Coordinates = .init(
            latitude: currentPosition.lat,
            longitude: currentPosition.lng
          )
          moveCamera(view, to: mapPoint, zoomLevel: 17)
        } else {
          fitMarkersZoomOnly(view: view, items: items)
        }
        isTrashDataFirstLoad = false
      } else {
        fitMarkersInCenter(view: view, items: items)
      }
    }
  }
  
  /// 나타날 마커들의 가운데 지점으로 카메라 이동
  private func fitMarkersInCenter(view: NMFNaverMapView, items: [TrashSpot]) {
    let mid = averageCenter(of: items.map { $0.location })
    moveCamera(view, to: mid, zoomLevel: view.mapView.cameraPosition.zoom)
  }
  
  /// 모든 마커가 지도 상에 보이도록 카메라 및 줌 조정
  private func fitMarkersZoomOnly(
    view: NMFNaverMapView,
    items: [TrashSpot],
    bottomPadding: CGFloat = 83
  ) {
    guard !items.isEmpty else { return }
    
    let center = view.mapView.cameraPosition.target
    let centerPoint = Coordinates(latitude: center.lat, longitude: center.lng)
    let markerPoints = items.map { $0.location }
    
    // 가장 먼 거리(미터 단위)
    let maxDistance = markerPoints.map { $0.distance(to: centerPoint) }.max() ?? 0
    
    // 실제로 보이는 지도 높이 계산
    let mapViewHeight = view.frame.height
    let padding: CGFloat = bottomPadding + 30 // 30은 여유치
    let usableMapHeight = mapViewHeight - padding
    guard usableMapHeight > 0 else { return }
    
    // 실제 지도 높이에 최대 거리가 다 들어오려면 필요한 zoomLevel 계산
    // 지도 SDK 기준: 한 줌 단계마다 2배로 크기가 늘어남
    let worldMeters: Double = 40075016.6855785
    
    // 비율: usable map 영역이 전체 중 차지하는 비율
    let visibleRatio = Double(usableMapHeight / mapViewHeight)
    // 한 화면에서 모든 마커가 다 보이려면 중심 기준 maxDistance*2 만큼 필요
    let neededMeters = maxDistance * 2 / visibleRatio
    
    let targetZoom = log2(worldMeters / neededMeters)
    // 제한(줌 너무 가까이/멀리 못 가게)
    let clampedZoom = max(min(targetZoom, 18), 8)
    
    let cameraUpdate = NMFCameraUpdate(scrollTo: center, zoomTo: clampedZoom)
    cameraUpdate.animation = .easeIn
    cameraUpdate.animationDuration = 1.0
    view.mapView.moveCamera(cameraUpdate)
  }
  
}
