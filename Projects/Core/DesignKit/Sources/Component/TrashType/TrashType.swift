//
//  TrashType.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import UIKit
import NMapsMap

public enum TrashType: String, Sendable {
  case general = "GENERAL"
  case recycle = "RECYCLE"
  
}

public extension TrashType {
  var title: String {
    switch self {
    case .general:
      "일반 쓰레기"
    case .recycle:
      "재활용 쓰레기"
    }
  }
  
  private static let activePinImages: [Self: NMFOverlayImage] = [
    .general: NMFOverlayImage(image: Icons.normalTrashPin.image),
    .recycle: NMFOverlayImage(image: Icons.recycleTrashPin.image)
  ]
  
  private static let inactivePinImages: [Self: NMFOverlayImage] = [
    .general: NMFOverlayImage(image: Icons.normalTrash.image),
    .recycle: NMFOverlayImage(image: Icons.recycleTrash.image)
  ]
  
  var activePinImage: NMFOverlayImage {
    Self.activePinImages[self]!
  }
  
  var inactiveImage: NMFOverlayImage {
    Self.inactivePinImages[self]!
  }
}
