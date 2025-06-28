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
    public var selectedPhoto: UIImage? = nil /// 선택된 사진
    public var isEnabled: Bool = false
    public init() { }
  }
  
  public enum Action: BindableAction, Equatable {
    @CasePathable
    public enum PhotoConfirmationDialog: Equatable {
      case takePhotoButtonTapped
      case selectPhotoButtonTapped
    }
    
    case destination(PresentationAction<Destination.Action>)
    
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    case centerButtonTapped /// 1. 사진이 없을 떄, 2. 사진이 있을 떄
    case photoTaken(UIImage) /// 사진이 선택되었을 때
    
    case willAppearPhotoConfirmationDialog
    
    public enum Delegate: Equatable {
      case photoSelected(UIImage) /// 사진이 선택되었을 때
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .centerButtonTapped:
        return .send(.willAppearPhotoConfirmationDialog)
      case let .photoTaken(image):
        state.selectedPhoto = image /// 선택된 사진 저장
        state.isEnabled = true /// 사진이 선택되었으므로, 버튼 활성화
        state.destination = nil /// 현재 화면 제거
        return .send(.delegate(.photoSelected(image)))
      case .willAppearPhotoConfirmationDialog:
        state.destination = .confirmationDialog(.makePhotoConfirmationDialog)
        return .none
      case .destination(.presented(.confirmationDialog(.takePhotoButtonTapped))):
        state.destination = .camera(CameraPickerFeature.State())
        return .none
      case .destination(.presented(.confirmationDialog(.selectPhotoButtonTapped))):
        state.destination = .photoLibraryPicker(PhotoLibraryPickerFeature.State())
        return .none
      /// 각 화면에서 사진 선택 과정을 진행 후, delegate로 처리되는 action
      case let .destination(.presented(.camera(.delegate(.photoTaken(photo))))):
        return .send(.photoTaken(photo))
      case let .destination(.presented(.photoLibraryPicker(.delegate(.photoSelected(photo))))):
        return .send(.photoTaken(photo))
      case .destination(.presented(.camera(.delegate(.cancelled)))):
        state.destination = nil /// 카메라 화면 제거
        return .none
      case .destination(.presented(.photoLibraryPicker(.delegate(.cancelled)))):
        state.destination = nil /// 사진 선택 화면 제거
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
  @Reducer(state: .equatable, action: .equatable)
  public enum Destination {
    case addCompleteReport
    case confirmationDialog(ConfirmationDialogState<SelectPhotoFeature.Action.PhotoConfirmationDialog>)
    case camera(CameraPickerFeature)
    case photoLibraryPicker(PhotoLibraryPickerFeature)
  }
}

extension ConfirmationDialogState where Action == SelectPhotoFeature.Action.PhotoConfirmationDialog {
  public static let makePhotoConfirmationDialog = Self {
    TextState("")
  } actions: {
    ButtonState(action: .takePhotoButtonTapped) { TextState("사진 찍기") }
    ButtonState(action: .selectPhotoButtonTapped) { TextState("사진 보관함에서 선택") }
    ButtonState(role: .cancel) { TextState("취소") }
  }
}
  
