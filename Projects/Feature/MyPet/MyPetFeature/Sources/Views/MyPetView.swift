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
      GeometryReader { proxy in
        ContentView(safeAreaBottomInset: proxy.safeAreaInsets.bottom)
          .onAppear() {
            store.send(.onAppear)
          }
          .background(
            ColorSet.Background.Primary
              .ignoresSafeArea()
          )
      }
    } destination: { store in
      switch store.case {
      case let .petDetail(store):
        MyPetDetailView(store: store)
      case let .changeNickname(store):
        ChangeMyPetNicknameView(store: store)
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
  private func ContentView(safeAreaBottomInset: CGFloat) -> some View {
    if store.isLoggedIn {
      ZStack {
        GeometryReader { proxy in
          MainView(safeAreaBottomInset: safeAreaBottomInset)
            .overlay(alignment: .bottomTrailing) {
              IconButton(icon: .info) {
                store.send(.petDescriptionButtonTapped)
              }
              .padding(.trailing, .Number16)
              .padding(.bottom, .Number156 + .Number16)
            }
          CustomBottomSheet(
            minHeight: .Number156,
            maxHeight: proxy.size.height,
            midHeight: .Number200,
            isBottomSheetDragEnabled: $bottomSheetDragEnabled,
            smallContent: { SmallBottomSheetContent },
            largeContent: { BigBottomSheetContent }
          )
        }
        .padding(.bottom, 50)
        if store.isPresentedPetDescription {
          PetDescriptionView(
            onDismiss: { store.send(.dismissPetDescription) }
          )
        }
      }
    } else {
      ZStack {
        ColorSet.Background.Primary
          .ignoresSafeArea()
        RequireLoginView
      }
    }
  }
  
  @ViewBuilder
  private func MainView(safeAreaBottomInset: CGFloat) -> some View {
    ZStack {
      VStack {
        Spacer()
        LinearGradient(
          gradient: Gradient(
            colors: [
              ColorSet.HexColor._9Fd5Fb,
              ColorSet.HexColor._A3D9FF
            ]
          ),
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: 330 * UIScreen.main.bounds.height / 812 - safeAreaBottomInset)
      }
      
      VStack(spacing: .Number0) {
        CardView
          .padding(.Number16)
        ZStack {
          CatShadowView
            .offset(y: 135)
          CatImageView
            .padding(.bottom, -(74 * UIScreen.main.bounds.height / 812))
          
          if store.showBubble {
            BubbleView(text: store.bubbleText)
              .offset(x: store.bubbleOffset.x, y: store.bubbleOffset.y)
              .transition(.scale.combined(with: .opacity))
              .animation(.spring(response: 0.3, dampingFraction: 0.8), value: store.showBubble)
              .zIndex(2)
              .allowsHitTesting(false)
          }
          
          if store.showShineLottieAnimation {
            TapCatImageWithShine
              .frame(width: .Number220, height: .Number220)
              .position(store.tapMyPetLocation)
              .allowsHitTesting(false)
              .transition(.opacity)
              .zIndex(1)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, .Number156 + .Number50)
      }
    }
    .background(
      LinearGradient(
        gradient: Gradient(
          colors: [
            ColorSet.HexColor._E0F2Ff,
            ColorSet.HexColor._D7E4F8
          ]
        ),
        startPoint: .top,
        endPoint: .bottom
      )
    )
  }
  
  @ViewBuilder
  private var CatShadowView: some View {
    Ellipse()
      .fill(
        RadialGradient(
          gradient: Gradient(stops: [
            .init(color: ColorSet.HexColor._006F9D.opacity(0.3), location: 0),
            .init(color: ColorSet.HexColor._006F9D.opacity(0), location: 1)
          ]),
          center: .center,
          startRadius: 0,
          endRadius: 77
        )
      )
      .frame(width: 153, height: 52)
      .blur(radius: 6)
  }
  
  @ViewBuilder
  private var CatImageView: some View {
    Image(
      asset: CatImageSet.imgae(
        level: store.myPetInfo?.levelType,
        interaction: store.isMyPetInteracted,
        type: ._2025_07
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
          let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
          impactFeedback.impactOccurred()
          
          var newLocation = location
          newLocation.y -= .Number220
          store.send(.catImageTapped(newLocation))
        }
    )
  }
  
  @ViewBuilder
  private var BigBottomSheetContent: some View {
    VStack {
      BigBottomSheetContentView(
        store: store.scope(state: \.petGrowthList, action: \.petGrowthList),
        startBottomSheetInsideScroll: $startBottomSheetInsideScroll,
        bottomSheetDragEnabled: $bottomSheetDragEnabled
      )
    }
  }
  
  @ViewBuilder
  private var SmallBottomSheetContent: some View {
    VStack {
      BigBottomSheetContentView(
        store: store.scope(state: \.petGrowthList, action: \.petGrowthList),
        startBottomSheetInsideScroll: $startBottomSheetInsideScroll,
        bottomSheetDragEnabled: $bottomSheetDragEnabled
      )
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
      .frame(width: .loginButtonWidth)
      
      Spacer()
    }
  }
}


