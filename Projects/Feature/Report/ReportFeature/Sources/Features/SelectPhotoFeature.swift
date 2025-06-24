//
//  SelectPhotoFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import AVFoundation
import SwiftUI
import ComposableArchitecture

import Utility

@Reducer
public struct SelectPhotoFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    
    public var isEnabled: Bool = false
    public var isCameraPreviewPresented: Bool = false
    public var cameraService: CameraService?
    public var session: AVCaptureSession?
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case centerButtonTapped
    case openCameraPreview
    case startCameraSession
    
    public enum Delegate: Equatable {
      case selectPhotoButtonTapped
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .centerButtonTapped:
        return .send(.delegate(.selectPhotoButtonTapped))
      case .openCameraPreview:
        state.isCameraPreviewPresented = true
        return .none
      case .startCameraSession:
        let cameraService = CameraService()
        state.cameraService = cameraService
        state.session = state.cameraService?.session
        return .run { send in
          try await cameraService.setUpCamera()
        }
      default: return .none
      }
    }
  }
}
