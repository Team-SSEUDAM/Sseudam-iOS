//
//  SpotSuggestionCompleteView.swift
//
//  SpotSuggestionComplete
//
//  Created by yongin
//
import SwiftUI
import ComposableArchitecture
import DesignKit

public struct SpotSuggestionCompleteView: View {
  @Bindable var store: StoreOf<SpotSuggestionCompleteFeature>
  
  private let image: ImageSet
  private let title: String
  private let description: String
  
  public init(
    image: ImageSet,
    title: String,
    description: String,
    store: StoreOf<SpotSuggestionCompleteFeature>
  ) {
    self.image = image
    self.title = title
    self.description = description
    self.store = store
  }

  public var body: some View {
    ZStack(alignment: .top) {
      ColorSet.Background.Primary
      VStack(spacing: .Number0) {
        PointView
        MainView
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      ToastView
    }
  }
  
  @ViewBuilder
  private var MainView: some View {
    VStack(alignment: .center, spacing: .Number20) {
      Icon(image: image, size: .Number200)
      VStack(spacing: .Number8) {
        Text(title)
          .font(FontSet.Heading.heading1)
          .foregroundStyle(ColorSet.Text.Primary)
        Text(description)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
    }
    .padding(.Number16)
  }
    
  
  @ViewBuilder
  private var PointView: some View {
    VStack(alignment: .center) {
      HStack(alignment: .center) {
        Spacer()
        if let petInfo = store.petInfo {
          LevelBar(
            currentLevel: petInfo.levelType,
            currentPoint: petInfo.currentPoint,
            addPoint: store.sseudamPoint.point,
            maxLevelPoint: petInfo.goalPoint,
            startAnimation: $store.startLevelAnimation
          )
          .opacity(store.showLevelBar ? 1 : 0)
          .animation(.easeIn(duration: 0.1), value: store.showLevelBar)
        }
      }
      .padding(.top, .Number16)
      .frame(height: .Number48)
    }
  }
  
  @ViewBuilder
  private var ToastView: some View {
    VStack {
      SnackBar(attributedMessage: $store.toastMessage) {
        store.send(.dismissToastMessage)
      }
    }
    .padding(.horizontal, .Number16)
  }
}
