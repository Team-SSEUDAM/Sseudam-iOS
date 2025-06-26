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
    @Presents var destination: Destination.State?
    
    public var isEnabled: Bool = false
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    @CasePathable
    public enum PhotoConfirmationDialog: Equatable {
      case takePhotoButtonTapped
      case selectPhotoButtonTapped
      case selectPhotoFromLibraryButtonTapped
    }
    
    case destination(PresentationAction<Destination.Action>)
    
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case centerButtonTapped /// 1. 사진이 없을 떄, 2. 사진이 있을 떄
    
    case willAppearPhotoConfirmationDialog
    
    public enum Delegate: Equatable { }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .centerButtonTapped:
        return .send(.willAppearPhotoConfirmationDialog)
      case .willAppearPhotoConfirmationDialog:
        state.destination = .confirmationDialog(.makePhotoConfirmationDialog)
        return .none
      case .destination(.presented(.confirmationDialog(.takePhotoButtonTapped))):
        state.destination = nil /// 다이얼로그 제거 후 카메라 화면으로 이동
        state.destination = .camera(CameraPickerFeature.State())
        return .none
      case .destination(.presented(.confirmationDialog(.selectPhotoButtonTapped))):
        state.destination = nil /// 다이얼로그 제거 후 사진 선택 화면으로 이동
        state.destination = .photoLibraryPicker(PhotoLibraryPickerFeature.State())
        return .none
      case .destination(.presented(.confirmationDialog(.selectPhotoFromLibraryButtonTapped))):
        state.destination = nil /// 다이얼로그 제거 후 파일 선택 화면으로 이동
        state.destination = .fileDocumentPicker(FileDocumentPickerFeature.State())
        return .none
      case .binding:
        return .none
        default: return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination.body
    }
  }
}

extension SelectPhotoFeature {
  @Reducer
  public enum Destination {
    case addCompleteReport
    case confirmationDialog(ConfirmationDialogState<SelectPhotoFeature.Action.PhotoConfirmationDialog>)
    case camera(CameraPickerFeature)
    case photoLibraryPicker(PhotoLibraryPickerFeature)
    case fileDocumentPicker(FileDocumentPickerFeature)
  }
}

extension SelectPhotoFeature.Destination.Action: Equatable { }
extension SelectPhotoFeature.Destination.State: Equatable { }

extension ConfirmationDialogState where Action == SelectPhotoFeature.Action.PhotoConfirmationDialog {
  public static let makePhotoConfirmationDialog = Self {
    TextState("")
  } actions: {
    ButtonState(action: .takePhotoButtonTapped) { TextState("사진 찍기") }
    ButtonState(action: .selectPhotoButtonTapped) { TextState("사진 보관함에서 선택") }
    ButtonState(action: .selectPhotoFromLibraryButtonTapped) { TextState("파일에서 선택") }
    ButtonState(role: .cancel) { TextState("취소") }
  }
}
  
