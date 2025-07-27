//
//  TrashFilterView.swift
//  HomeFeature
//
//  Created by 조용인 on 7/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import TrashSpotDomainInterface
import DesignKit

/// 쓰레기통 종류 필터에 사용하기 위한 FilterView
public struct TrashFilterView: View {
  
  @State private var selectedFilter: TrashFilterType = .all
  private var onFilterSelected: (TrashType?) -> Void
  
  public init(onFilterSelected: @escaping (TrashType?) -> Void) {
    self.onFilterSelected = onFilterSelected
  }
  private let filters: [TrashFilterType] = [.all, .general, .recycle]
  
  public var body: some View {
    HStack(spacing: .Number8) {
      ForEach(filters, id: \.self) { filter in
        FilterButton(title: filter.title, icon: filter.icon, isActive: selectedFilter == filter)
          .onTapGesture {
            guard selectedFilter != filter else { return }
            selectedFilter = filter
            // 'all'은 nil, 나머지는 TrashType 반환
            let trashType: TrashType? = {
              switch filter {
              case .all: return nil
              case .general: return .general
              case .recycle: return .recycle
              }
            }()
            onFilterSelected(trashType)
          }
      }
      Spacer()
    }
  }
}

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
