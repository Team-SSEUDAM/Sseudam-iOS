//
//  PhotoLibraryPickerView.swift
//  SelectSpotImageFeature
//
//  Created by 조용인 on 7/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture
import DesignKit

public struct PhotoLibraryPickerView: View {
  let store: StoreOf<PhotoLibraryPickerFeature>
  @State private var selectedItem: PhotosPickerItem?
  
  public var body: some View {
    NavigationStack {
      PhotosPicker(
        selection: $selectedItem,
        matching: .images
      ) {
        VStack {
          Text("사진을 선택하세요")
            .font(FontSet.Title.title2)
        }
      }
      .navigationTitle("사진 선택")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("취소") {
            store.send(.delegate(.cancelled))
          }
        }
      }
      .onChange(of: selectedItem) { oldItem, newItem in
        Task {
          if let data = try? await newItem?.loadTransferable(type: Data.self),
             let image = UIImage(data: data) {
            store.send(.delegate(.photoSelected(image)))
          }
        }
      }
    }
  }
}

