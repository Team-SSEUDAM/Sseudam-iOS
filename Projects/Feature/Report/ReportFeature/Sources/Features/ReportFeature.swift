//
//  ReportFeature.swift
//
//  Report
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import Utility
import NMReverseGeocodingDomainInterface
import DesignKit

@Reducer
public struct ReportFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    var currentPage: Int = 0
    var moveLocation: MoveLocationFeature.State = MoveLocationFeature.State()
    var writeName: WriteNameFeature.State = WriteNameFeature.State()
    var selectKind: SelectKindFeature.State = SelectKindFeature.State()
    var selectPhoto: SelectPhotoFeature.State = SelectPhotoFeature.State()
    
    var nextButtonState: PrimaryButtonState = .normal
    var nextButtonText: String = "시작하기"
    
    /// 제보하기에 담길 데이터
    var spotName: String = ""
    var centerPoint: Coordinates?
    var nmReverseGeoCodeEntity: NMGeoCodeReverseEntity?
    var trashType: String = ""
    
    var selectedPhoto: UIImage? = nil
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case moveLocation(MoveLocationFeature.Action)
    case writeName(WriteNameFeature.Action)
    case selectKind(SelectKindFeature.Action)
    case selectPhoto(SelectPhotoFeature.Action)
    case binding(BindingAction<State>)
    
    /// 시작 화면이 나타날 때
    case didAppearStartReport
    /// 위치 선택 화면이 나타날 때
    case didAppearMoveLocation
    /// 이름 작성 화면이 나타날 때
    case didAppearWriteName
    /// 종류 선택 화면이 나타날 때
    case didAppearSelectKind
    /// 사진 선택 화면이 나타날 때
    case didAppearSelectPhoto
    
    case nextButtonIsEnabled(Bool)
    case nextButtonTapped
    case reportButtonTapped
    
    case backButtonTapped
    case pop
    case backPageTapped
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.moveLocation, action: \.moveLocation) { MoveLocationFeature() }
    Scope(state: \.writeName, action: \.writeName) { WriteNameFeature() }
    Scope(state: \.selectKind, action: \.selectKind) { SelectKindFeature() }
    Scope(state: \.selectPhoto, action: \.selectPhoto) { SelectPhotoFeature() }
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        switch state.currentPage {
        case 0: return .send(.pop) /// RecordFeature에서 처리
        default: return .send(.backPageTapped)
        }
      case .backPageTapped:
        state.currentPage = max(state.currentPage - 1, 0)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearMoveLocation)
        case 2: return .send(.didAppearWriteName)
        case 3: return .send(.didAppearSelectKind)
        case 4: return .send(.didAppearSelectPhoto)
        default: return .none
        }
      case .nextButtonTapped:
        if state.currentPage == 4 { return .send(.reportButtonTapped) }
        state.currentPage = min(state.currentPage + 1, 4)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearMoveLocation)
        case 2: return .send(.didAppearWriteName)
        case 3: return .send(.didAppearSelectKind)
        case 4: return .send(.didAppearSelectPhoto)
        default: return .none
        }
      case let .nextButtonIsEnabled(isEnabled):
        state.nextButtonState = isEnabled ? .normal : .disabled
        return .none
      case .didAppearStartReport:
        state.nextButtonText = "시작하기"
        return .send(.nextButtonIsEnabled(true))
      case .didAppearMoveLocation:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(false))),
          .send(.nextButtonIsEnabled(state.moveLocation.isEnabled))
        ])
      case .didAppearWriteName:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(true))),
          .send(.nextButtonIsEnabled(state.writeName.isEnabled))
        ])
      case .didAppearSelectKind:
        state.nextButtonText = "다음"
        return .merge([
          .send(.writeName(.injectedFocus(false))),
          .send(.nextButtonIsEnabled(state.selectKind.isEnabled))
        ])
      case .didAppearSelectPhoto:
        state.nextButtonText = "제보하기"
        return .merge([
          .send(.nextButtonIsEnabled(state.selectPhoto.isEnabled))
        ])
      /// `MoveLocationFeature`의 `Delegate`처리
      case let .moveLocation(.delegate(action)):
        if state.currentPage != 1 { return .none }
        switch action {
        case let .centerChanged(location, entity):
          state.centerPoint = location
          state.nmReverseGeoCodeEntity = entity
          return .send(.nextButtonIsEnabled(location != nil && entity != nil))
        }
      /// `WriteNameFeature`의 `Delegate`처리
      case let .writeName(.delegate(action)):
        if state.currentPage != 2 { return .none }
        switch action {
        case let .nameChanged(spotName):
          state.spotName = spotName
          return .send(.nextButtonIsEnabled(!spotName.isEmpty))
        }
      /// `SelectKindFeature`의 `Delegate`처리
      case let .selectKind(.delegate(action)):
        if state.currentPage != 3 { return .none }
        switch action {
        case let .didSelectKind(trashType):
          state.trashType = trashType
          return .send(.nextButtonIsEnabled(true))
        }
      /// `SelectPhotoFeature`의 `Delegate`처리
      case let .selectPhoto(.delegate(action)):
        if state.currentPage != 4 { return .none }
        switch action {
        case let .photoSelected(photo):
          state.selectedPhoto = photo /// 사진은, 일반적인 ReportBody에 담지 않고, presignedURL로 별도 처리
          return .send(.nextButtonIsEnabled(true))
        }
      case .reportButtonTapped:
        // TODO: 제보하기 버튼이 눌렸을 때, 실제 제보하기 기능 호출
        
        return .none
      case .binding:
        return .none
        default: return .none
      }
    }
  }
}
