//
//  CameraPickerView.swift
//  SelectSpotImageFeature
//
//  Created by 조용인 on 7/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct CameraPickerView: View {
  let store: StoreOf<CameraPickerFeature>
  
  public var body: some View {
    CameraPickerRepresentable { image in
      store.send(.delegate(.photoTaken(image)))
    } onCancel: {
      store.send(.delegate(.cancelled))
    }
    .ignoresSafeArea()
  }
}
