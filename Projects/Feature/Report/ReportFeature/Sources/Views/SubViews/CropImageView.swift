//
//  CropImageView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct CropImageView: View {
  @Bindable var store: StoreOf<CropImageFeature>
  
  public init(store: StoreOf<CropImageFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Gray._1000.ignoresSafeArea()
      VStack {
        Spacer().frame(height: .Number48)
        GeometryReader { geometry in
          let size = min(geometry.size.width, geometry.size.height)
          cropImageArea(with: size, proxy: geometry)
        }
        .padding(.horizontal, .Number16)
        .padding(.vertical, .Number24)
        bottomNavigationBar
      }
    }
    .onAppear {
      store.send(.viewDidAppear)
    }
  }
  
  @ViewBuilder
  private var bottomNavigationBar: some View {
    HStack(alignment: .center) {
      Button(
        action: { store.send(.cancel) }
      ) {
        Icon(
          image: .close,
          size: .Number32,
          renderingMode: .template,
          color: ColorSet.Gray._0
        )
      }
      Spacer()
      Button(
        action: { store.send(.confirmCrop) }
      ) {
        Icon(
          image: .check,
          size: .Number32,
          renderingMode: .template,
          color: ColorSet.Gray._0
        )
      }
    }
    .padding(.horizontal, .Number16)
    .frame(height: .Number48)
  }
  
  @ViewBuilder
  private func cropImageArea(with cropSize: CGFloat, proxy: GeometryProxy) -> some View {
    ZStack {
      StaticImageView(
        image: store.originalImage,
        size: .init(width: proxy.size.width, height: proxy.size.height)
      )
      CropOverlayView(
        gridSize: $store.gridSize,
        gridPosition: $store.gridPosition,
        proxy: proxy,
        imageRatio: calculateImageRatio()
      )
    }
    .background(ColorSet.Component.Error.opacity(0.3))
    .onAppear {
      let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
      store.send(.setGridSize(cropSize))
      store.send(.setGridPosition(center))
    }
  }
  
  private func calculateImageRatio() -> CGSize {
    let image = store.originalImage
    let width = image.size.width
    let height = image.size.height
    let ratio = width / height
    return ratio > 1 ? CGSize(width: ratio, height: 1) : CGSize(width: 1, height: 1 / ratio)
  }
}

struct StaticImageView: View {
  let image: UIImage
  let size: CGSize
  
  var body: some View {
    Image(uiImage: image)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: size.width, height: size.height)
      .clipped()
  }
}
