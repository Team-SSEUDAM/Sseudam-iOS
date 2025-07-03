//
//  SelectSpotNameView.swift
//
//  SelectSpotName
//
//  Created by yongin
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SelectSpotNameView: View {
  @Bindable var store: StoreOf<SelectSpotNameFeature>
  
  public init(store: StoreOf<SelectSpotNameFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text("길찾기 힌트가 될 수 있는\n쓰레기통 이름을 입력해주세요")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
        .padding(.top, .Number8)
      CustomTextField(
        placeholder: "지하철 역 4번 출구, OO카페 맞은편",
        text: $store.name,
        state: .constant(store.textFieldState),
        isFocused: $store.isFocused
      ) {
        Text(store.errorMessage)
      }
      Spacer()
    }
    .padding(.horizontal, .Number16)
  }
}
