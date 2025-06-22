//
//  TrashFilterType.swift
//  DesignKit
//
//  Created by Jiyeon on 6/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum TrashFilterType: Hashable {
  case all
  case general
  case recycle

  var title: String {
    switch self {
    case .all:
      "전체"
    case .general:
      "일반 쓰레기"
    case .recycle:
      "재활용 쓰레기"
    }
  }

  var icon: ImageSet? {
    switch self {
    case .all:
      return nil
    case .general:
      return .delete
    case .recycle:
      return .recycle
    }
  }

}
