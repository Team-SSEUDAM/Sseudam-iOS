//
//  WriteNameView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct WriteNameView: View {
  @Bindable var store: StoreOf<WriteNameFeature>
  
  public init(store: StoreOf<WriteNameFeature>) {
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
        state: $store.textFieldState,
        injectedFocus: .constant(true)
      ) {
        switch store.validation {
        case let .invalid(errorMessage): Text(errorMessage)
        case let .none(placeholder): Text(placeholder)
        case .valid: Text("")
        }
      }
    }
    .padding(.horizontal, .Number16)
  }
}

#Preview {
    WriteNameView(
      store: StoreOf<WriteNameFeature>(
        initialState: WriteNameFeature.State(),
        reducer: { WriteNameFeature() }
      )
    )
}
