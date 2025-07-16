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
        MainView
        CustomBottomSheet(
          minHeight: .Number72,
          midHeight: .Number100,
          isBottomSheetDragEnabled: $bottomSheetDragEnabled,
          smallContent: { SmallBottomSheetContent },
          largeContent: { BigBottomSheetContent }
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
    ZStack {
      VStack {
        CardView
          .padding(.Number16)
        Spacer()
      }
    }
    .background(ColorSet.Background.Accent)
  }
  
  @ViewBuilder
  private var BigBottomSheetContent: some View {
    let catCards = [
      CatCard(image: "cat1", isLocked: false),
      CatCard(image: "cat2", isLocked: false),
      CatCard(image: nil, isLocked: true),
      CatCard(image: nil, isLocked: true),
      CatCard(image: nil, isLocked: true),
      CatCard(image: nil, isLocked: true)
    ]
    
    let growthRecords = [
      GrowthRecord(level: "Lv.1", title: "작고 소중한 {{고양이 이름}}", description: "", date: "YY.MM.DD.", stampCount: "0쓰담", isLocked: false),
      GrowthRecord(level: "Lv.2", title: "호기심 가득한 {{고양이 이...", description: "", date: "YY.MM.DD.", stampCount: "20쓰담", isLocked: false),
      GrowthRecord(level: "Lv.3", title: "쑥쑥 자라나는 {{고양이...", description: "", date: "", stampCount: "110쓰담", isLocked: true),
      GrowthRecord(level: "Lv.4", title: "왕 커서 귀여운{{고양이 이...", description: "", date: "", stampCount: "N쓰담", isLocked: true),
      GrowthRecord(level: "Special", title: "{{스페셜 문구}} {{고양이...", description: "", date: "", stampCount: "N쓰담", isLocked: true)
    ]
    
    
    VStack(alignment: .center) {
      CommonHeaderView
      
      // 고양이 카드 가로 스크롤
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(catCards) { card in
            CatCardCell(card: card)
          }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
      }
      .simultaneousGesture(
        DragGesture()
          .onChanged { value in
            if startBottomSheetInsideScroll {
              let horizontalAmount = abs(value.translation.width) > 10 ? abs(value.translation.width) : 0
              let verticalAmount = abs(value.translation.height) > 10 ? abs(value.translation.height) : 0
              bottomSheetDragEnabled = verticalAmount > horizontalAmount
              startBottomSheetInsideScroll = false
            }
          }
          .onEnded { _ in
            startBottomSheetInsideScroll = true
            bottomSheetDragEnabled = true
          }
      )
      
      // 성장 기록 섹션 헤더
      Text("성장 기록")
        .font(FontSet.Body.body2)
        .foregroundColor(ColorSet.Text.Primary)
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // 성장 기록 리스트 (스크롤 가능)
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(spacing: 0) {
          ForEach(growthRecords) { record in
            VStack(spacing: 0) {
              GrowthRecordCell(record: record)
            }
          }
        }
      }
    }
    .padding(.vertical, .Number8)
  }
  
  @ViewBuilder
  private var SmallBottomSheetContent: some View {
    CommonHeaderView
  }
  
  @ViewBuilder
  private var CommonHeaderView: some View {
    HStack(alignment: .center) {
      Text("내가 살린 고양이")
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


