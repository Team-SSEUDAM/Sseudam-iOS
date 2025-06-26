//
//  MapViewRepresentable+.swift
//  HomeFeature
//
//  Created by Jiyeon on 6/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import TrashSpotDomainInterface

extension MapViewRepresentable {
  
  /// 현재 지도 범위를 가져오는 메서드
  func onReceiveMapBounds(_ action: @escaping ([MapPoint]) -> Void) -> Self {
    var map = self
    map.mapBounds = action
    return map
  }
  func markerTapped(_ action: @escaping (Int?) -> Void) -> Self {
    var map = self
    map.onMarkerTapped = action
    return map
  }
  func didTapMap(_ action: @escaping () -> Void) -> Self {
    var map = self
    map.didTapMap = action
    return map
  }
}

