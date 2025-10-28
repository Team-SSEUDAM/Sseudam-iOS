//
//  MapMarkerEntity.swift
//  HomeFeature
//
//  Created by Jiyeon on 10/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility
import TrashSpotDomainInterface

/// MapViewRepresentable에서 사용하기 위한 엔티티
///
/// 좌표, 쓰레기통 타입에 대한 데이터를 가지고 있음
public struct MapMarkerEntity: Equatable {
  var point: Coordinates
  var type: TrashType
}
