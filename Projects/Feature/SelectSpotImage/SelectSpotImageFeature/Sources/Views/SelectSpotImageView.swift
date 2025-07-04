//
//  SelectSpotImageView.swift
//
//  SelectSpotImage
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture

import DesignKit

public struct SelectSpotImageView: View {
  @Bindable var store: StoreOf<SelectSpotImageFeature>
  
  public init(store: StoreOf<SelectSpotImageFeature>) {
    self.store = store
  }
  
  public var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: .Number24) {
        VStack(alignment: .leading, spacing: .Number8) {
          Text("쓰레기통 사진을 업로드해주세요")
            .font(FontSet.Heading.heading1)
            .foregroundColor(ColorSet.Text.Primary)
          Text("정확한 정보 검증을 위해 사진이 필요해요.")
            .font(FontSet.Body.body3)
            .foregroundColor(ColorSet.Text.Secondary)
        }
        photoImageView
          .aspectRatio(1, contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: .Number16))
          .onTapGesture { store.send(.centerButtonTapped) }
      }
      .padding(.horizontal, .Number16)
      .padding(.vertical, .Number24)
      Spacer()
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.camera, action: \.destination.camera)
    ) { store in
      CameraPickerView(store: store)
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.photoLibraryPicker, action: \.destination.photoLibraryPicker)
    ) { store in
      PhotoLibraryPickerView(store: store)
    }
    .fullScreenCover(
      item: $store.scope(state: \.destination?.cropImage, action: \.destination.cropImage)
    ) { store in
      CropImageView(store: store)
    }
    .confirmationDialog($store.scope(state: \.destination?.confirmationDialog, action: \.destination.confirmationDialog))
  }
  
  @ViewBuilder
  private var photoImageView: some View {
    ZStack {
      ColorSet.Background.Secondary
      if let uiImage = store.selectedPhoto {
        selectedPhotoView(uiImage: uiImage)
      } else {
        defaultPhotoView
      }
    }
  }
  
  @ViewBuilder
  private var defaultPhotoView: some View {
    Icon(
      image: .arrowCircleUp,
      size: .Number64,
      renderingMode: .template
    )
    .foregroundColor(ColorSet.Gray._200)
  }
  
  @ViewBuilder
  private func selectedPhotoView(uiImage: UIImage) -> some View {
    Image(uiImage: uiImage)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
