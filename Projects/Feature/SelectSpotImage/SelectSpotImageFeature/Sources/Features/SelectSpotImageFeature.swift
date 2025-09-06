//
//  SelectSpotImageFeature.swift
//
//  SelectSpotImage
//
//  Created by yongin
//

import AVFoundation
import SwiftUI
import ComposableArchitecture

import Utility

@Reducer
public struct SelectSpotImageFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    public var selectedPhoto: UIImage? = nil /// 최종 선택된 사진 (크롭 완료)
    public var originalPhoto: UIImage? = nil /// 원본 사진 (크롭 전)
    public var isEnabled: Bool = false
    public var photoType: String = ""
        
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
    case mixPanel(MixPanel)
    
    case centerButtonTapped /// 1. 사진이 없을 떄, 2. 사진이 있을 떄
    case photoTaken(UIImage) /// 사진이 선택되었을 때
    case photoCropped(UIImage) /// 크롭이 완료되었을 때
        
    case willAppearPhotoConfirmationDialog
    
    public enum Delegate: Equatable {
      case photoSelected(UIImage) /// 사진이 선택되었을 때
    }
    
    public enum MixPanel: Equatable {
      case suggestionUploadPhoto(file_size: Int, photo_type: String)
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce {
      state,
      action in
      switch action {
      case .centerButtonTapped:
        return .send(.willAppearPhotoConfirmationDialog)
        
      case let .photoTaken(image):
        state.originalPhoto = image
        state.destination = .cropImage(CropImageFeature.State(originalImage: image))
        return .none
        
      case let .photoCropped(croppedImage):
        state.selectedPhoto = croppedImage
        state.isEnabled = true
        state.destination = nil
        let photoSize = croppedImage.pngData()?.count ?? 0
        return .merge(
          .send(.mixPanel(.suggestionUploadPhoto(file_size: photoSize, photo_type: state.photoType))
          ),
          .send(.delegate(.photoSelected(croppedImage)))
        )
        
      case .willAppearPhotoConfirmationDialog:
        state.destination = .confirmationDialog(.makePhotoConfirmationDialog)
        return .none
        
      case .destination(.presented(.confirmationDialog(.takePhotoButtonTapped))):
        state.photoType = "camera"
        state.destination = .camera(CameraPickerFeature.State())
        return .none
        
      case .destination(.presented(.confirmationDialog(.selectPhotoButtonTapped))):
        state.photoType = "photo_library"
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
        
        /// 크롭 화면에서의 delegate 처리
      case let .destination(.presented(.cropImage(.delegate(.imageCropped(croppedImage))))):
        return .send(.photoCropped(croppedImage))
        
      case .destination(.presented(.cropImage(.delegate(.cancelled)))):
        state.originalPhoto = nil
        state.destination = nil
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

extension SelectSpotImageFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Destination {
    case addCompleteReport
    case confirmationDialog(ConfirmationDialogState<SelectSpotImageFeature.Action.PhotoConfirmationDialog>)
    case camera(CameraPickerFeature)
    case photoLibraryPicker(PhotoLibraryPickerFeature)
    case cropImage(CropImageFeature)
  }
}

extension ConfirmationDialogState where Action == SelectSpotImageFeature.Action.PhotoConfirmationDialog {
  public static let makePhotoConfirmationDialog = Self {
    TextState("")
  } actions: {
    ButtonState(action: .takePhotoButtonTapped) { TextState("사진 찍기") }
    ButtonState(action: .selectPhotoButtonTapped) { TextState("사진 보관함에서 선택") }
    ButtonState(role: .cancel) { TextState("취소") }
  }
}
  
