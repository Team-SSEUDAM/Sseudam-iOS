//
//  SuggestionView.swift
//
//  Suggestion
//
//  Created by yongin
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

public struct SuggestionView: View {
  @Bindable var store: StoreOf<SuggestionFeature>
  
  public init(store: StoreOf<SuggestionFeature>) {
    self.store = store
  }
  
  public var body: some View {
    GeometryReader { geo in
      ZStack {
        VStack(spacing: .Number0) {
          ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: .Number16) {
                VStack(spacing: .Number0) {
                  Spacer().frame(height: .Number48)
                  SuggestionStartView(
                    image: .suggestTrash,
                    title: "발견한 쓰레기통을 제보해주세요!",
                    description:"쓰담이 아직 모르는 쓰레기통이 있나요?\n제보 시 5쓰담이 적립되며,\n승인되면 15쓰담을 추가 적립받아요.")
                  .frame(width: geo.size.width)
                  .id(0)
                }
                VStack(spacing: .Number0) {
                  Spacer().frame(height: .Number48)
                  SelectSpotLocationView(
                    store: store.scope(state: \.child.moveLocation, action: \.child.moveLocation)
                  )
                  .frame(width: geo.size.width)
                  .id(1)
                }
                VStack(spacing: .Number0) {
                  Spacer().frame(height: .Number48)
                  SelectSpotNameView(
                    store: store.scope(state: \.child.writeName, action: \.child.writeName)
                  )
                  .frame(width: geo.size.width)
                  .id(2)
                }
                VStack(spacing: .Number0) {
                  Spacer().frame(height: .Number48)
                  SelectSpotCategoryView(
                    store: store.scope(state: \.child.selectKind, action: \.child.selectKind)
                  )
                  .frame(width: geo.size.width)
                  .id(3)
                }
                VStack(spacing: .Number0) {
                  Spacer().frame(height: .Number48)
                  SelectSpotImageView(
                    store: store.scope(state: \.child.selectPhoto, action: \.child.selectPhoto)
                  )
                  .frame(width: geo.size.width)
                  .id(4)
                }
                SpotSuggestionCompleteView(
                  image: .addSpot,
                  title: "제보가 완료되었어요!",
                  description:"심사는 1-2일이 소요되며,\n승인되면 15쓰담을 추가 적립 받아요.",
                  store: store.scope(state: \.child.complete, action: \.child.complete)
                )
                .frame(width: geo.size.width)
                .id(5)
              }
            }
            .onChange(of: store.currentPage) { prev, next in
              withAnimation { proxy.scrollTo(next, anchor: .center) }
            }
            .scrollDisabled(true)
          }
          nextButton
            .padding(.horizontal, .Number16)
            .padding(.vertical, .Number24)
            .navigationBarBackButtonHidden(true)
        }
        if !store.isNavigationBarHidden {
          VStack(spacing: .Number0) {
            navigationBar
            Spacer()
          }
        }
      }
    }
    .background(ColorSet.Background.Primary)
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
  }
  
  
  
  /// 네비게이션 바
  @ViewBuilder
  private var navigationBar: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron) {
          store.send(.backButtonTapped)
        }
      }
    )
    .blockBackToSwipe()
    .frame(height: .Number48)
  }
  
  @ViewBuilder
  private var nextButton: some View {
    if store.isPhotoPage && !store.child.selectPhoto.isEnabled {
      // 사진 선택 페이지에서 사진이 선택되지 않았을 때 SecondaryButton 사용
      SecondaryButton(
        loadingView: {
          DotLottieAnimation(
            fileName: LottieSet.loading.name,
            config: AnimationConfig(autoplay: true, loop: true)
          ).view()
        },
        isLoading: $store.isLoading,
        title: $store.nextButtonText,
        size: .large,
        state: .constant(.normal)
      ) {
        store.send(.suggestionButtonTapped)
      }
    } else {
      // 그 외의 경우 PrimaryButton 사용
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
        if store.currentPage == 4 { store.send(.suggestionButtonTapped) }
        else { store.send(.nextButtonTapped) }
      }
    }
  }
}
