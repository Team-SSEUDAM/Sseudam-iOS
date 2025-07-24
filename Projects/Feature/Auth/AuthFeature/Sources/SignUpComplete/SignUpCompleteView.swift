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
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        VStack(alignment: .center, spacing: .Number16) {
          Spacer()
          ContentView
          Spacer()
          PrimaryButton(
            title: .constant("쓰담 시작하기"), 
            size: .large, 
            state: .constant(.normal), {
            store.send(.startButtonTapped)
          })
          .padding(.Number16)
        }
      }
    }
  }
  
  @ViewBuilder
  private var ContentView: some View {
    VStack(alignment: .center, spacing: .Number16) {
      Image(asset: ImageSet.welcome.swiftUIImage)
        .frame(width: .Number200, height: .Number200)
      if let nickname = store.state.nickname {
        Text("\(nickname)님,\n만나서 반가워요!")
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
          .multilineTextAlignment(.center)
      }
      Text("쓰담과 함께하는 올바른 환경 습관,\n지금 시작해볼까요?")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
        .multilineTextAlignment(.center)
    }
  }
}
