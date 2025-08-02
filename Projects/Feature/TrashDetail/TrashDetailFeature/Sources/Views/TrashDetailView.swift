//
//  TrashDetailView.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import TrashSpotDomainInterface
import Utility
import DotLottie

public struct TrashDetailView: View {
  @Bindable var store: StoreOf<TrashDetailFeature>
  @Environment(\.scenePhase) private var scenePhase
  
  public init(store: StoreOf<TrashDetailFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
      if store.isEmptyList {
        EmptyDataView
      } else {
        if let data = store.trashDetail {
          DetailContent(data: data)
        } else if store.isFailLoadDetail {
          ErrorView
        } else {
          loadingView
        }
      }
      
    }
  }
  
  @ViewBuilder
  private var loadingView: some View {
    DotLottieAnimation(
      fileName: LottieSet.dot_loading.name,
      config: AnimationConfig(autoplay: true, loop: true)
    )
    .view()
    .frame(width: .Number100, height: .Number100)
  }
  
  @ViewBuilder
  private func DetailContent(data: TrashSpotDetail) -> some View {
    VStack(spacing: .Number16) {
      HStack(spacing: .Number16) {
        VStack(alignment: .leading, spacing: .Number8) {
          TrashLocationView(name: data.name, address: data.address)
          BadgesView(
            trashType: data.trashType.title,
            suggestionName: data.suggestionerName,
            visitedCount: data.visitedCount
          )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        if data.isPublicData {
          publicDataImageView
        } else {
          trashImageView
        }
      }
      ButtonsView
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number20)
    .onAppear {
      LocationService.shared.startTracking()
    }
    .onDisappear {
      LocationService.shared.stopTracking()
    }
    .task { @MainActor in
      for await _ in LocationService.shared.userLocationStream {
        store.send(.visited(.fetchUserLocation))
      }
    }
    .onChange(of: scenePhase) { _, newValue in
      switch newValue {
      case .active:
        LocationService.shared.startTracking()
      case .background:
        LocationService.shared.stopTracking()
      default:
        break
      }
    }
  }
  
  @ViewBuilder
  private var trashImageView: some View {
    if let data = store.trashImageData,
       let image = UIImage.downsampled(from: data, to: .init(width: .Number80, height: .Number80)) {
      Image(uiImage: image)
        .resizable()
        .clipShape(RoundedRectangle(cornerRadius: .Number8))
        .frame(width: .Number80, height: .Number80)
    } else {
      Rectangle()
        .fill(ColorSet.Background.Secondary)
        .clipShape(RoundedRectangle(cornerRadius: .Number8))
        .frame(width: .Number80, height: .Number80)
    }
  }
  
  
  @ViewBuilder
  private var publicDataImageView: some View {
    VStack(spacing: .Number0) {
      Text("DATA")
        .font(FontSet.customBoldFont(size: 14))
        .foregroundStyle(ColorSet.Text.Secondary)
      Text("공공데이터포털\n제공")
        .font(FontSet.Caption.caption2)
        .multilineTextAlignment(.center)
        .foregroundStyle(ColorSet.Text.Secondary)
    }
    .frame(width: .Number80, height: .Number80)
    .background(ColorSet.Background.Secondary)
    .clipShape(RoundedRectangle(cornerRadius: .Number8))
    .overlay(
      RoundedRectangle(cornerRadius: .Number8)
        .stroke(style: StrokeStyle(lineWidth: .Number1, dash: [5])) // 점선 설정
        .foregroundColor(ColorSet.Border.Primary)
    )
  }
  
  @ViewBuilder
  private var EmptyDataView: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center, spacing: .Number20) {
        Icon(
          image: .sentimentDissatisfied,
          size: .Number32,
          renderingMode: .template,
          color: ColorSet.Icon.Secondary
        )
        VStack(alignment: .center, spacing: .Number16) {
          Text("이 근방에는 쓰레기통이 없어요.")
            .foregroundStyle(ColorSet.Text.Secondary)
          PrimaryButton(
            title: .constant("제보하러 가기"),
            size: .medium,
            state: .constant(.normal)
          ) {
            print("제보하러 가기")
          }
          .frame(width: 116)
        }
      }
    }
  }
  
  @ViewBuilder
  private func TrashLocationView(name: String, address: String) -> some View {
    VStack(alignment: .leading, spacing: .Number4) {
      Text(name)
        .font(FontSet.Heading.heading3)
        .foregroundStyle(ColorSet.Text.Primary)
      Text(address)
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private func BadgesView(
    trashType: String,
    suggestionName: String?,
    visitedCount: Int
  ) -> some View {
    HStack(spacing: .Number4) {
      Badge(text: .constant(trashType), state: .primary)
      if let name = suggestionName {
        Badge(text: .constant(name), state: .primary, icon: .verified, suffix: " 제보")
      } else {
        Badge(text: .constant("공공데이터포털"), state: .primary, icon: .verified)
      }
      Badge(text: .constant("인증 \(visitedCount)회"), state: .primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private var ButtonsView: some View {
    GeometryReader { geo in
      HStack(spacing: .Number8) {
        SecondaryButton(title: "수정 제안하기", size: .medium) {
          store.send(.reportButtonTapped)
        }
        .frame(width: (geo.size.width - .Number8) / 3)
        
        PrimaryButton(
          title: $store.visited.visitedButtonText,
          size: .medium,
          state: $store.visited.visitedButtonState
        ) {
          print(store.visited.visitedButtonState, store.visited)
          store.send(.visited(.visitButtonTapped))
        }
        .onTapGesture {
          if !store.visited.visitedState.buttonEnable {
            store.send(.visited(.visitButtonTapped))
          }
        }
        .frame(width: (geo.size.width - .Number8) * 2 / 3)
        
      }
    }
    .frame(maxWidth: .infinity)
    
  }
  
  @ViewBuilder
  private var ErrorView: some View {
    HStack(alignment: .center) {
      VStack(alignment: .center, spacing: .Number20) {
        Icon(
          image: .sentimentDissatisfied,
          size: .Number32,
          renderingMode: .template,
          color: ColorSet.Icon.Secondary
        )
        Text("쓰레기통 정보를 가져오는데 실패했어요.")
          .foregroundStyle(ColorSet.Text.Secondary)
      }
    }
  }
}


