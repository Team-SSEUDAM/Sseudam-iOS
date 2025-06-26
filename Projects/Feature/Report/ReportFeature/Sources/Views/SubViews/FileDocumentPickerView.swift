//
//  FileDocumentPickerView.swift
//  ReportFeature
//
//  Created by 조용인 on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

public struct FileDocumentPickerView: View {
  let store: StoreOf<FileDocumentPickerFeature>
  
  public var body: some View {
    DocumentPickerRepresentable { image in
      store.send(.delegate(.fileSelected(image)))
    } onCancel: {
      store.send(.delegate(.cancelled))
    }
  }
}

