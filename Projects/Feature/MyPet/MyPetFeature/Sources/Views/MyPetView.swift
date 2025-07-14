//
//  MyPetView.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct MyPetView: View {
  @Bindable var store: StoreOf<MyPetFeature>
  
  public init(store: StoreOf<MyPetFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ContentView
  }
  
  @ViewBuilder
  private var ContentView: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      if store.isLoggedIn { MainView }
      else { RequireLoginView }
    }
  }
  
  @ViewBuilder
  private var MainView: some View {
    ColorSet.Background.Primary
      .ignoresSafeArea()
      .draggableBottomSheet(
        isPresented: .constant(true),
        isIgnoreTabBar: .constant(true),
        smallHeight: 68,
        smallContent: { Text("내 반려동물") },
        largeContent: { Text("내 반려동물 상세 정보") }
      )
      
    
  }
  
  @ViewBuilder
  private var RequireLoginView: some View {
    VStack(alignment: .center, spacing: .Number16) {
      Spacer()
      Text("로그인이 필요해요")
        .font(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
      Text("로그인하면 나의 제보, 인증 내역을 관리할 수 있어요.")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
      PrimaryButton(
        title: .constant("로그인하러 가기"),
        size: .large,
        state: .constant(.normal)
      ) {
        store.send(.requestLogin(true, .mypet))
      }
      .frame(width: 129)
      
      Spacer()
    }
  }
}


