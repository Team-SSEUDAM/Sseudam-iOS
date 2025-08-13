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
import ReportDomainInterface
import TrashSpotDomainInterface

import SelectSpotImageFeature
import SelectSpotCategoryFeature
import SelectSpotNameFeature
import SelectSpotLocationFeature

import DesignKit

@Reducer
public struct ReportFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    
    var currentPage: Int = 0
    var trashSpotDetail: TrashSpotDetail
    var trashSpotRegion: String?
    var trashSpotCity: String?
    var trashSpotSite: String?
      
    
    /// 하위 `Feature`
    var selectedReportInfo: SelectReportInfoTypeFeature.State
    var child: ReportChildFeature.State
    
    /// 다음 버튼 관련 `State`
    var nextButtonState: PrimaryButtonState = .normal
    var nextButtonIsHidden: Bool = false
    var nextButtonText: String = "시작하기"
    var isNavigationBarHidden = false
    var isLoading: Bool = false
    
    /// 선택된 정보 관련 `State`
    var selectedReportInfoType: String = "" /// 선택된 제보 정보 타입
    var selectedPhoto: UIImage? = nil
    
    /// 신고하기 데이터 모델
    var reportSpotDetail: TrashSpotFlattenDetailEntity?
    
    public init(
      _ detail: TrashSpotDetail,
      currentLocation: Coordinates? = nil
    ) {
      self.trashSpotDetail = detail
      self.selectedReportInfo = SelectReportInfoTypeFeature.State()
      self.child = ReportChildFeature.State(detail, currentLocation: currentLocation)
    }
  }
  
  public enum Action: BindableAction, Equatable {
    @CasePathable
    public enum Alert: Equatable { }
    
    case destination(PresentationAction<Destination.Action>)
    case selectedReportInfo(SelectReportInfoTypeFeature.Action)
    case child(ReportChildFeature.Action)
    case binding(BindingAction<State>)
    
    case combineSpotReportModel
    case spotReportResult(Result<String?, NetworkError>)
    case uploadReportSpotImageResult(Result<String, NetworkError>)
    case postSpotImage(String)
    
    case setIsLoading(Bool)
    case errorOccured(message: String)
    
    /// 시작 화면이 나타날 때
    case didAppearStartReport
    /// 신고할 정보 타입 선택 화면이 나타날 때
    case didAppearSelectReportInfo
    /// 위치 선택 화면이 나타날 때
    case didAppearMoveLocation
    /// 이름 작성 화면이 나타날 때
    case didAppearWriteName
    /// 종류 선택 화면이 나타날 때
    case didAppearSelectKind
    /// 사진 선택 화면이 나타날 때
    case didAppearSelectPhoto
    /// 완료 화면이 등장했을 때
    case didAppearComplete
    
    case nextButtonIsEnabled(Bool)
    case nextButtonTapped
    
    case checkReportInfoType /// 신고할 정보 타입 선택 화면에서, 다음 버튼 클릭 시 호출됨
    case validateSpotNameButtonTapped /// 이름 작성 화면에서, 서버검증 요청
    case reportButtonTapped /// 제보하기 화면에서, 서버 검증 요청
    
    
    case backButtonTapped
    case pop(TrashSpotDetail)
    case backPageTapped
  }
  
  @Dependency(\.ReportSpotUseCase) var reportSpotUseCase
  @Dependency(\.UploadReportSpotImageUseCase) var uploadReportSpotImageUseCase
  @Dependency(\.FetchTrashSpotRawDetailUseCase) var fetchTrashSpotRawDetailUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.selectedReportInfo, action: \.selectedReportInfo) {
      SelectReportInfoTypeFeature()
    }
    // Child를 하나의 Scope로 관리
    Scope(state: \.child, action: \.child) {
      ReportChildFeature()
    }
    
    Reduce { state, action in
      switch action {
      case .backButtonTapped:
        switch state.currentPage {
        case 0: return .send(.pop(state.trashSpotDetail)) /// RecordFeature에서 처리
        default: return .send(.backPageTapped)
        }
        
      case .backPageTapped:
        state.currentPage = max(state.currentPage - 1, 0)
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearSelectReportInfo)
        default: return .none
        }
        
      case .nextButtonTapped:
        if state.currentPage == 3 { return .send(.pop(state.trashSpotDetail)) }
        state.currentPage = min(state.currentPage + 1, 3)
        /// 다음 페이지에 따라 적절한 action을 보냄
        switch state.currentPage {
        case 0: return .send(.didAppearStartReport)
        case 1: return .send(.didAppearSelectReportInfo)
        case 2: return .send(.checkReportInfoType)
        case 3: return .send(.didAppearComplete)
        default: return .none
        }
        
      case let .nextButtonIsEnabled(isEnabled):
        state.nextButtonState = isEnabled ? .normal : .disabled
        return .none
        
      case .didAppearStartReport:
        state.nextButtonText = "시작하기"
        state.nextButtonIsHidden = false
        return .send(.nextButtonIsEnabled(true))
      
      case .didAppearSelectReportInfo:
        state.nextButtonIsHidden = true
        return .send(.child(.writeName(.focusChanged(false))))
        
      case .didAppearMoveLocation:
        if state.selectedReportInfoType != "POINT" { return .none }
        state.nextButtonText = "완료"
        return .send(.nextButtonIsEnabled(state.child.moveLocation.isEnabled))
        
      case .didAppearWriteName:
        if state.selectedReportInfoType != "NAME" { return .none }
        state.nextButtonText = "완료"
        return .merge([
          .send(.child(.writeName(.focusChanged(true)))),
          .send(.nextButtonIsEnabled(state.child.writeName.isButtonEnabled))
        ])
        
      case .didAppearSelectKind:
        if state.selectedReportInfoType != "KIND" { return .none }
        state.nextButtonText = "완료"
        return .send(.nextButtonIsEnabled(state.child.selectKind.isEnabled))
        
      case .didAppearSelectPhoto:
        if state.selectedReportInfoType != "PHOTO" { return .none }
        state.nextButtonText = "완료"
        return .send(.nextButtonIsEnabled(state.child.selectPhoto.isEnabled))
        
      case .didAppearComplete:
        state.nextButtonText = "확인"
        state.isNavigationBarHidden = true
        return .merge([
          .send(.child(.writeName(.focusChanged(false)))),
          .send(.nextButtonIsEnabled(true))
        ])
        
      case let .selectedReportInfo(.delegate(selectAction)):
        switch selectAction {
        case let .didSelectKind(type):
          state.selectedReportInfoType = type
          state.nextButtonIsHidden = false
          return .send(.nextButtonTapped)
        }
        
        /// Child에서 오는 Delegate 처리
      case let .child(.delegate(delegateAction)):
        switch delegateAction {
        case let .moveLocation(action): return handleMoveLocationDelegate(state: &state, action: action)
        case let .writeName(action): return handleWriteNameDelegate(state: &state, action: action)
        case let .selectKind(action): return handleSelectKindDelegate(state: &state, action: action)
        case let .selectPhoto(action): return handleSelectPhotoDelegate(state: &state, action: action)
        }
        
      case .checkReportInfoType:
        let selectedType = state.selectedReportInfoType
        switch selectedType {
        case "POINT": return .send(.didAppearMoveLocation) /// 위치 선택 페이지로 이동
        case "NAME": return .send(.didAppearWriteName) /// 이름 작성 페이지로 이동
        case "KIND": return .send(.didAppearSelectKind) /// 종류 선택 페이지로 이동
        case "PHOTO": return .send(.didAppearSelectPhoto) /// 사진 선택 페이지로 이동
        default: return .none
        }
        
      case .validateSpotNameButtonTapped:
        return .run { send in
          await send(.setIsLoading(true))
          await send(.child(.writeName(.validateNameFromServer)))
        }
        
      case .reportButtonTapped:
        if state.selectedReportInfoType == "NAME" { return .send(.validateSpotNameButtonTapped) }
        return .send(.combineSpotReportModel)
        
      case let .postSpotImage(prisignedURL):
        return uploadReportSpotImageEffect(state, prisignedURL, uploadReportSpotImageUseCase)
        
      case .combineSpotReportModel:
        let reportSpotDetail = TrashSpotFlattenDetailEntity(
          id: state.trashSpotDetail.id,
          latitude: state.trashSpotDetail.point.latitude,
          longitude: state.trashSpotDetail.point.longitude,
          spotName: state.trashSpotDetail.name,
          region: state.trashSpotRegion,
          city: state.trashSpotCity,
          site: state.trashSpotSite,
          trashType: state.trashSpotDetail.trashType.rawValue,
        )
        state.reportSpotDetail = reportSpotDetail
        return spotReportEffect(state, reportSpotUseCase)
        
      case let .spotReportResult(result):
        switch result {
        case let .success(optionalPresignedURL):
          if let presignedURL = optionalPresignedURL { return .send(.postSpotImage(presignedURL)) }
          else {
            return .merge([
              .send(.setIsLoading(false)),
              .send(.nextButtonTapped)
            ])
          }
          
        case let .failure(error):
          return .send(.errorOccured(message: error.localizedDescription))
        }
        
      case let .uploadReportSpotImageResult(result):
        switch result {
        case .success:
          return .merge([
            .send(.setIsLoading(false)),
            .send(.nextButtonTapped)
          ])
        
        case let .failure(error):
          return .send(.errorOccured(message: error.localizedDescription))
        }
        
      case let .errorOccured(message):
        state.destination = .alert(.occuredError(message))
        return .send(.setIsLoading(false))
        
      case let .setIsLoading(isLoading):
        state.nextButtonState = isLoading ? .loading : state.nextButtonState
        state.isLoading = isLoading
        return .none
        
      case .destination(.dismiss):
        state.destination = nil
        return .none
        
      case .destination:
        return .none
        
      case .child:
        return .none
        
      case .selectedReportInfo:
        return .none
        
      case .binding:
        return .none
        
      case .pop:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination.body
    }
  }
}

// MARK: - Delegate Handlers
private extension ReportFeature {
  
  /// `MoveLocationFeature` Delegate 처리
  func handleMoveLocationDelegate(
    state: inout State,
    action: SelectSpotLocationFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 2 else { return .none }
    
    switch action {
    case let .nowCalculateReverseGeoCode(isLoading):
      return .send(.setIsLoading(isLoading))
      
    case let .centerChanged(location, entity):
      if let location = location { state.trashSpotDetail.point = location }
      if let entity = entity {
        state.trashSpotRegion = entity.region
        state.trashSpotCity = entity.city
        state.trashSpotSite = entity.site
      }
      return .send(.nextButtonIsEnabled(location != nil && entity != nil))
    }
  }
  
  /// `WriteNameFeature(쓰레기통 이름 작성)` Delegate 처리
  func handleWriteNameDelegate(
    state: inout State,
    action: SelectSpotNameFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 2 else { return .none }
    
    switch action {
    case let .localValidationCompleted(isValid, _):
      return .send(.nextButtonIsEnabled(isValid))
      
    case let .serverValidationCompleted(isValid, name):
      state.trashSpotDetail.name = name
      if isValid { return .send(.combineSpotReportModel) }
      else {
        return .run { send in
          await send(.setIsLoading(false))
          await send(.nextButtonIsEnabled(false))
        }
      }
    }
  }
  
  /// `SelectSpotCategoryFeature(쓰레기 종류 선택)` Delegate 처리
  func handleSelectKindDelegate(
    state: inout State,
    action: SelectSpotCategoryFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 2 else { return .none }
    
    switch action {
    case let .didSelectKind(trashType):
      state.trashSpotDetail.trashType = TrashType(rawValue: trashType) ?? .general
      return .send(.nextButtonIsEnabled(true))
    }
  }
  
  /// `SelectPhotoFeature(사진 선택)` Delegate 처리
  func handleSelectPhotoDelegate(
    state: inout State,
    action: SelectSpotImageFeature.Action.Delegate
  ) -> Effect<Action> {
    guard state.currentPage == 2 else { return .none }
    
    switch action {
    case let .photoSelected(photo):
      state.selectedPhoto = photo
      return .send(.nextButtonIsEnabled(true))
    }
  }
}

/// MARK: - 순수하게 `ReportFeature`에서 사용할 `Effect들
public extension ReportFeature {
  
  func spotReportEffect(
    _ state: Self.State,
    _ useCase: ReportSpotUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        let entity = try await useCase.execute(
          state.selectedReportInfoType,
          state.reportSpotDetail
        )
        await send(.spotReportResult(.success(entity)))
      } catch is CancellationError {
        await send(.spotReportResult(.failure(.taskCancelled)))
      } catch {
        await send(.spotReportResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  func uploadReportSpotImageEffect(
    _ state: Self.State,
    _ url: String,
    _ useCase: UploadReportSpotImageUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        guard let image = state.selectedPhoto else {
          throw NetworkError.customError(message: "이미지를 선택해주세요.")
        }
        try await useCase.execute(image, url)
        await send(.uploadReportSpotImageResult(.success("성공"))) /// 임시 메시지
      } catch is CancellationError {
        await send(.uploadReportSpotImageResult(.failure(.taskCancelled)))
      } catch {
        await send(.uploadReportSpotImageResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
}

extension ReportFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Destination {
    case alert(AlertState<ReportFeature.Action.Alert>)
  }
}


extension AlertState where Action == ReportFeature.Action.Alert {
  static func occuredError(_ message: String) -> Self {
    Self {
      TextState("제보하기 도중에 오류가 발생했습니다.")
    } message: {
      TextState(message)
    }
  }
}
