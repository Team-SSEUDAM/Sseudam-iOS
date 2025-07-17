//
//  MyPetView.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import DotLottie
import DesignKit

public struct MyPetView: View {
  @Bindable var store: StoreOf<MyPetFeature>
  
  @State private var bottomSheetDragEnabled: Bool = true
  @State private var startBottomSheetInsideScroll: Bool = true
    
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
        GeometryReader { proxy in
          MainView
          CustomBottomSheet(
            minHeight: .Number72,
            maxHeight: proxy.size.height,
            midHeight: .Number200,
            isBottomSheetDragEnabled: $bottomSheetDragEnabled,
            smallContent: { SmallBottomSheetContent },
            largeContent: { BigBottomSheetContent }
          )
        }
      }
      .padding(.bottom, 50)
    }
    else {
      RequireLoginView
    }
  }
  
  @ViewBuilder
  private var MainView: some View {
    ZStack {
      VStack {
        Spacer()
        ColorSet.Mint._100
          .frame(height: .Number230)
          .offset(y: -.Number50)
      }
        
      VStack {
        CardView
          .padding(.Number16)
        Group {
          ZStack {
            Ellipse()
              .fill(
                RadialGradient(
                  gradient: Gradient(stops: [
                    .init(color: Color(hex: "#006F9D").opacity(0.3), location: 0),
                    .init(color: Color(hex: "#006F9D").opacity(0), location: 1)
                  ]),
                  center: .center,
                  startRadius: 0,
                  endRadius: 77
                )
              )
              .frame(width: 153, height: 52)
              .blur(radius: 6)
              .offset(y: 90)
            
            // 고양이 이미지
            Image(
              asset: CatImageSet.imgae(
                level: store.myPetInfo?.levelType,
                interaction: store.isMyPetInteracted,
                type: .basic
              )
            )
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(height: .Number220)
            .overlay(
              Color.clear
                .contentShape(Rectangle())
                .allowsHitTesting(true)
                .onTapGesture(coordinateSpace: .global) { location in
                  var newLocation = location
                  newLocation.y -= .Number220
                  store.send(.catImageTapped(newLocation))
                }
            )
            
            if store.showShineLottieAnimation {
              TapCatImageWithShine
                .frame(width: .Number220, height: .Number220)
                .position(store.tapMyPetLocation)
                .allowsHitTesting(false)
                .transition(.opacity)
                .zIndex(1)
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .background(ColorSet.Background.Accent)
  }
  
  @ViewBuilder
  private var BigBottomSheetContent: some View {
    VStack {
      CommonHeaderView
      BigBottomSheetContentView(
        catCards: store.catCards,
        growthRecords: store.growthRecords,
        startBottomSheetInsideScroll: $startBottomSheetInsideScroll,
        bottomSheetDragEnabled: $bottomSheetDragEnabled
      )
    }
  }
  
  @ViewBuilder
  private var SmallBottomSheetContent: some View {
    CommonHeaderView
  }
  
  @ViewBuilder
  private var CommonHeaderView: some View {
    HStack(alignment: .center) {
      Text("내가 돌본 고양이")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
        .padding(.horizontal, .Number16)
      Spacer()
      Icon(
        image: .rightChevron,
        size: .Number24,
        renderingMode: .template,
        color: ColorSet.Icon.Primary
      )
      .padding(.trailing, .Number8)
    }
    .onTapGesture {
      store.send(.petDetailButtonTapped)
    }
  }
  
  @ViewBuilder
  private var TapCatImageWithShine: some View {
    DotLottieAnimation(
      fileName: LottieSet.tap_shine.name,
      config: AnimationConfig(autoplay: true, loop: false)
    )
    .view()
    .id(UUID())
  }
  
  // MARK: - 더미데이터로 주입한 카드 뷰
  @ViewBuilder
  private var CardView: some View {
    MyPetCardView(
      myPetInfo: store.myPetInfo
    ) {
      store.send(.petNicknameButtonTapped)
    }
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


