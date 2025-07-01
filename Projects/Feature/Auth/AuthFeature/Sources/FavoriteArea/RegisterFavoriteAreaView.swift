//
//  FavoriteAreaView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct RegisterFavoriteAreaView: View {
  
  @Bindable var store: StoreOf<RegisterFavoriteAreaFeature>
  
  public init(store: StoreOf<RegisterFavoriteAreaFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(alignment: .leading) {
        NavigationBar(backContent:  {
          TouchArea(image: .leftChevron) {
            store.send(.dismiss)
          }
        })
        content
        
      }
      .navigationBarHidden(true)
    }
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(alignment: .leading)  {
      Title
      SearchTextView
      ZStack {
        SearchItemList(items: store.searchItems)
        VStack {
          Spacer()
          SnackBar(message: $store.errorToastMessage, {})
        }
      }
      .frame(maxHeight: .infinity)
      completeButton
      
    }
  }
  
  @ViewBuilder
  private var completeButton: some View {
    PrimaryButton(
      title: "완료",
      size: .large,
      state: store.isSelectItem ? .normal : .disabled
    ) {
      store.send(.completeButtonTapped)
    }
      .padding(.Number16)
  }
  
  @ViewBuilder
  private var Title: some View {
    Text("관심 지역을 입력해주세요")
      .font(FontSet.Heading.heading1)
      .foregroundStyle(ColorSet.Text.Primary)
      .padding(.vertical, .Number8)
      .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var SearchTextView: some View {
    CustomTextField(
      placeholder: "동명(읍, 면)으로 검색",
      text: $store.area.removeDuplicates(),
      state: store.isSelectItem ? .constant(.normal) : .constant(.accent),
      isFocused: $store.focusKeyboard
    )
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private func SearchItemList(items: [String]) -> some View {
    if !items.isEmpty {
      ScrollView(showsIndicators: true) {
        LazyVStack(spacing: .Number0) {
          ForEach(items, id: \.self) { area in
            Text(area)
              .font(FontSet.Body.body2)
              .foregroundStyle(ColorSet.Text.Primary)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.vertical, .Number12)
              .padding(.horizontal, .Number16)
              .background(ColorSet.Background.Primary)
              .contentShape(Rectangle())
              .onTapGesture {
                store.send(.selectArea(area))
              }
          }
        }
      }
      
      .background(.white)
      .animation(.easeInOut, value: items.count)
      .transition(.opacity)
    } else {
      Spacer()
    }
  }
  
}
