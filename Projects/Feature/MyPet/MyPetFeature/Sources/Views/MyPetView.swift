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
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
      ContentView
        .onAppear() {
          store.send(.onAppear)
        }
        .background(
          ColorSet.Background.Primary
            .ignoresSafeArea()
        )
    } destination: { store in
      switch store.case {
      case let .petDetail(store):
        MyPetDetailView(store: store)
      }
    }
    .onChange(of: store.path) { oldValue, newValue in
      /// 네비게이션 path의 `newValue`가 0이 되면 탭바는 등장
      if newValue.count == 0 { store.send(.delegate(.needToHiddenTabBar(false))) }
    }
    .transaction { transaction in
      transaction.disablesAnimations = false
    }
    
  }
  
  @ViewBuilder
  private var ContentView: some View {
    if store.isLoggedIn {
      ZStack {
        MainView
        CustomBottomSheet(
          minHeight: .Number72,
          smallContent: {
            Text("작은 시트")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(Color.yellow)
          },
          largeContent: {
            Text("큰 시트")
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(Color.yellow)
          }
        )
      }
      .padding(.bottom, 50)
    }
    else {
      RequireLoginView
    }
  }
  
  @ViewBuilder
  private var MainView: some View {
    
    VStack(spacing: 0) {
      // 상단 카드 뷰
      CardView
        .padding(.Number16)
      // 중간 펫 이미지 영역
      ZStack {
        // 배경색 (연한 파란색)
        ColorSet.Background.Accent
          .ignoresSafeArea()
        
        VStack {
          Spacer()
          
          // 펫 이미지 (임시로 원형 뷰)
          Circle()
            .fill(Color.orange.opacity(0.7))
            .frame(width: 150, height: 150)
            .overlay(
              VStack {
                Circle()
                  .fill(Color.black)
                  .frame(width: 4, height: 4)
                  .offset(x: -15, y: -10)
                Circle()
                  .fill(Color.black)
                  .frame(width: 4, height: 4)
                  .offset(x: 15, y: -30)
                Circle()
                  .fill(ColorSet.Background.Secondary)
                  .frame(width: 12, height: 8)
                  .offset(y: 5)
              }
            )
          Spacer()
        }
      }
    }
  }
  
  @ViewBuilder
  private var CardView: some View {
    MyPetCardView(
      level: 1,
      petNickName: "작고 소중한" + "{{고양이 이름}}",
      currentStamps: 10,
      goalStamp: 100,
      progress: .constant(30)
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
        store.send(.requestLogin)
      }
      .frame(width: 129)
      
      Spacer()
    }
  }
}


