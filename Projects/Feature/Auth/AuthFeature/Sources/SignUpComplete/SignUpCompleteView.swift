//
//  SignUpCompleteView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/28/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SignUpCompleteView: View {
  
  var store: StoreOf<SignUpCompleteFeature>
  
  public init(store: StoreOf<SignUpCompleteFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      VStack(alignment: .center, spacing: .Number16) {
        Spacer()
        // TODO: - 앱 로고 이미지로 바꾸기
        RoundedRectangle(cornerRadius: .Number8)
          .frame(width: 200, height: 200)
          .foregroundStyle(ColorSet.Background.Secondary)
        TitleView
        Spacer()
        PrimaryButton(title: "쓰담 시작하기", size: .large, state: .normal, {
          store.send(.startButtonTapped)
        })
        .padding(.Number16)
      }
      
    }
  }
  
  @ViewBuilder
  private var TitleView: some View {
    VStack(alignment: .center, spacing: .Number8) {
      Text("\(store.state.nickname ?? "")님,\n만나서 반가워요!")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
        .multilineTextAlignment(.center)
      Text("쓰담과 함께하는 올바른 환경 습관,\n지금 시작해볼까요?")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
        .multilineTextAlignment(.center)
    }
  }
}
