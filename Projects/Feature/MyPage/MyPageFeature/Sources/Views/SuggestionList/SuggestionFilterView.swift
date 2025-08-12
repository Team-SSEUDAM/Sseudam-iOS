//
//  SuggestionFilterView.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/12/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import HistoryDomainInterface
import DesignKit

/// 제보한 내역 필터에 사용하기 위한 FilterView
public struct SuggestionFilterView: View {
  
  @State private var selectedFilter: TrashFilterType = .all
  
  private let onFilterSelected: (ActionType) -> Void
  private let filters: [TrashFilterType] = [.all, .suggestion, .report]
  
  public init(
    onFilterSelected: @escaping (ActionType) -> Void
  ) {
    self.onFilterSelected = onFilterSelected
  }
  
  public var body: some View {
    HStack(spacing: .Number8) {
      ForEach(filters, id: \.self) { filter in
        FilterButton(title: filter.rawValue, isActive: selectedFilter == filter)
          .onTapGesture {
            guard selectedFilter != filter else { return }
            selectedFilter = filter
            let trashType: ActionType = {
              switch filter {
              case .all: return .unknown
              case .suggestion: return .suggestion
              case .report: return .report
              }
            }()
            onFilterSelected(trashType)
          }
      }
      Spacer()
    }
  }
}

public enum TrashFilterType: String, Hashable {
  case all = "전체"
  case suggestion = "신규 제보"
  case report = "수정 제안"
}
