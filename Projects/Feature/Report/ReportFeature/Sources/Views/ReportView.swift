//
//  ReportView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DotLottie
import SelectSpotCategoryFeature
import SelectSpotImageFeature
import SelectSpotNameFeature
import SelectSpotLocationFeature
import SpotSuggestionCompleteFeature
import DesignKit

public struct ReportView: View {
  @Bindable var store: StoreOf<ReportFeature>
  
  public init(store: StoreOf<ReportFeature>) {
    self.store = store
  }
  
  public var body: some View {
    GeometryReader { geo in
      VStack {
        navigationBar
        mainScrollView(width: geo.size.width)
        bottomButtonView
      }
      .navigationBarBackButtonHidden(true)
    }
    .background(ColorSet.Background.Primary)
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
  }
  
  // MARK: - View Components
  
  @ViewBuilder
  private func mainScrollView(width: CGFloat) -> some View {
    ScrollViewReader { proxy in
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: .Number16) {
          startView(width: width)
          selectInfoTypeView(width: width)
          selectedContentView(width: width)
          reportCompletedView(width: width)
        }
      }
      .onChange(of: store.currentPage) { prev, next in
        withAnimation { proxy.scrollTo(next, anchor: .center) }
      }
      .scrollDisabled(true)
    }
  }
  
  @ViewBuilder
  private func startView(width: CGFloat) -> some View {
    ReportStartView(
      image: .reportTrash,
      title: "잘못된 쓰레기통 정보를 \n발견했나요?",
      description: "수정 제안 시 5쓰담이 적립되며, \n승인되면 15쓰담을 추가 적립받아요."
    )
    .frame(width: width)
    .id(0)
  }
  
  @ViewBuilder
  private func selectInfoTypeView(width: CGFloat) -> some View {
    SelectReportInfoTypeView(
      store: store.scope(
        state: \.selectedReportInfo,
        action: \.selectedReportInfo
      )
    )
    .frame(width: width)
    .id(1)
  }
  
  @ViewBuilder
  private func selectedContentView(width: CGFloat) -> some View {
    Group {
      switch store.selectedReportInfoType {
      case "POINT":
        SelectSpotLocationView(
          store: store.scope(
            state: \.child.moveLocation,
            action: \.child.moveLocation
          )
        )
      case "NAME":
        SelectSpotNameView(
          store: store.scope(
            state: \.child.writeName,
            action: \.child.writeName
          )
        )
      case "KIND":
        SelectSpotCategoryView(
          store: store.scope(
            state: \.child.selectKind,
            action: \.child.selectKind
          )
        )
      case "PHOTO":
        SelectSpotImageView(
          store: store.scope(
            state: \.child.selectPhoto,
            action: \.child.selectPhoto
          )
        )
      default:
        EmptyView()
      }
    }
    .frame(width: width)
    .id(2)
  }
  
  @ViewBuilder
  private func reportCompletedView(width: CGFloat) -> some View {
    SpotSuggestionCompleteView(
      image: .addSpot,
      title: "제보가 완료되었어요!",
      description:"심사는 1-2일이 소요되며,\n승인되면 15쓰담을 추가 적립 받아요.",
      store: store.scope(state: \.child.complete, action: \.child.complete)
    )
    .frame(width: width)
    .id(3)
  }
  
  @ViewBuilder
  private var bottomButtonView: some View {
    nextButton
      .padding(.horizontal, .Number16)
      .padding(.vertical, .Number24)
      .overlay {
        if store.nextButtonIsHidden {
          ColorSet.Background.Primary
        }
      }
  }
  
  /// 네비게이션 바
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        if !store.isNavigationBarHidden {
          TouchArea(image: .leftChevron) {
            store.send(.backButtonTapped)
          }
        }
      }
    )
    .blockBackToSwipe()
  }
  
  @ViewBuilder
  private var nextButton: some View {
    PrimaryButton(
      loadingView: {
        DotLottieAnimation(
          fileName: LottieSet.loading.name,
          config: AnimationConfig(autoplay: true, loop: true)
        ).view()
      },
      isLoading: $store.isLoading,
      title: $store.nextButtonText,
      size: .large,
      state: $store.nextButtonState
    ) {
      if store.currentPage == 2 { store.send(.reportButtonTapped) }
      else { store.send(.nextButtonTapped) }
    }
  }
}
