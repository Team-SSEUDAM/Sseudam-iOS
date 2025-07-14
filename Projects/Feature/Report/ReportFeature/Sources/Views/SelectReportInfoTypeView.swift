//
//  SelectReportInfoTypeView.swift
//  ReportFeature
//
//  Created by 조용인 on 7/6/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SelectReportInfoTypeView: View {
  @Bindable var store: StoreOf<SelectReportInfoTypeFeature>
  
  public init(store: StoreOf<SelectReportInfoTypeFeature>) {
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
          text: "쓰레기통 위치",
          state: .constant(.normal)
        ) {
          store.send(.selectedKind(.location))
        }
        CheckBoxButton(
          text: "쓰레기통 이름",
          state: .constant(.normal)
        ) {
          store.send(.selectedKind(.name))
        }
        CheckBoxButton(
          text: "쓰레기통 종류",
          state: .constant(.normal)
        ) {
          store.send(.selectedKind(.kind))
        }
        CheckBoxButton(
          text: "쓰레기통 사진",
          state: .constant(.normal)
        ) {
          store.send(.selectedKind(.photo))
        }
        Spacer()
      }
    }
    .padding(.horizontal, .Number16)
  }
}
