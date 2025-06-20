//
//  FilterButtonList.swift
//  DesignKit
//
//  Created by Jiyeon on 6/20/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct FilterButtonList: View {
  
  @State private var selectedFilter: FilterButtonType = .all
  private var onFilterSelected: (TrashType?) -> Void
  
  public init(onFilterSelected: @escaping (TrashType?) -> Void) {
    self.onFilterSelected = onFilterSelected
  }
  private let filters: [FilterButtonType] = [.all, .general, .recycle]
  
  public var body: some View {
    HStack(spacing: .Number12) {
      ForEach(filters, id: \.self) { filter in
        FilterButton(type: filter, isActive: selectedFilter == filter)
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
