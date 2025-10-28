//
//  SelectSpotCategoryView.swift
//
//  SelectSpotCategory
//
//  Created by yongin
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SelectSpotCategoryView: View {
  @Bindable var store: StoreOf<SelectSpotCategoryFeature>
  
  public init(store: StoreOf<SelectSpotCategoryFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: .Number24) {
      Text("쓰레기통 종류를 선택해주세요")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.top, .Number8)
      VStack(spacing: .Number12) {
        CheckBoxButton(
          text: "일반, 재활용쓰레기통 모두 있어요",
          state: $store.selectedRecycle,
          icon: .recycle
        ) {
          store.send(.selectedKind(.recycle))
        }
        CheckBoxButton(
          text: "일반쓰레기통만 있어요",
          state: $store.selectedNormal,
          icon: .delete
        ) {
          store.send(.selectedKind(.normal))
        }
        Spacer()
      }
    }
    .padding(.horizontal, .Number16)
  }
}
