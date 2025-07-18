//
//  MyPetFeature.swift
//
//  MyPet
//
//  Created by yongin
//

import SwiftUI
import ComposableArchitecture
import UserDefaults
import Utility

import AuthFeature
import PetDomainInterface


@Reducer
public struct MyPetFeature {
  
  public init() {}
  
  @ObservableState
  public struct State {
    public var path = StackState<Path.State>()
    public var petGrowthList: MyPetGrowthListFeature.State
    
    public var myPetInfo: PetInfoEntity?
    
    /// 마이 펫 이미지 관련
    public var tapMyPetLocation: CGPoint = .zero
    public var showShineLottieAnimation: Bool = false
    public var isMyPetInteracted: Bool = false
    
    /// 버블 관련
    public var showBubble: Bool = false
    public var bubbleText: String = ""
    public var bubbleOffset: CGPoint = .zero
    
    public var isLoggedIn: Bool = false
    
    public var catCards: [CatCard] = []
    public var growthRecords: [GrowthRecord] = []
    
    public init() {
      self.petGrowthList = MyPetGrowthListFeature.State()
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case path(StackActionOf<Path>)
    case petGrowthList(MyPetGrowthListFeature.Action)
    case onAppear
    case checkLoggedIn
    case fetchMyPetInfo
    
    case fetchMyPetInfoResult(Result<PetInfoEntity, NetworkError>)
    case fetchMyPetLayout
    
    case petNicknameButtonTapped
    case petDetailButtonTapped
    
    case catImageTapped(CGPoint)
    case showShineLottieAnimation
    case hideShineLottieAnimation
    case resetInteractionState
    
    case requestLogin
    case hiddenTabBar(Bool)
    case delegate(Delegate)
    
  }
  
  public enum Delegate: Equatable {
    case needToHiddenTabBar(Bool)
    case requestLogin(Bool)
  }
  
  @Dependency(\.CheckPetInfoUseCase) var checkPetInfoUseCase
  
  private enum CancelID {
    case lottieAnimation
    case interactionState
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.petGrowthList, action: \.petGrowthList) {
      MyPetGrowthListFeature()
    }
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.checkLoggedIn)
        
      case .checkLoggedIn:
        state.isLoggedIn = UserDefaultsKeys.isLoggedIn ?? false
        if state.isLoggedIn { return .send(.fetchMyPetInfo) }
        return .none
        
      case .fetchMyPetInfo:
        return fetchMyPetInfoEffect(checkPetInfoUseCase)
        
      case let .fetchMyPetInfoResult(result):
        switch result {
        case let .success(entity):
          state.myPetInfo = entity
          /// TODO: - `GrowthListFeature`에 데이터 기반 레이아웃 호출
          return .send(.petGrowthList(.fetchGrowthList(entity)))
          
        case let .failure(error):
          state.myPetInfo = nil
          print("Error fetching pet info: \(error)")
          return .none
        }
        
      case .petDetailButtonTapped:
        state.path.append(.petDetail(MyPetDetailFeature.State()))
        return .send(.delegate(.needToHiddenTabBar(true)))
      case .petNicknameButtonTapped:
        print("petNicknameButtonTapped")
        return .none
        
      case let .catImageTapped(location):
        /// 이전 로띠가 표시 중이면 무시
        guard !state.showShineLottieAnimation else { return .none }
        if !state.showBubble {
          let randomXOffset: CGFloat = [-60, 60].randomElement() ?? 0
          state.bubbleOffset = CGPoint(x: randomXOffset, y: -140)
        }
        
        state.tapMyPetLocation = location
        state.isMyPetInteracted = true
        state.showShineLottieAnimation = true
        
        if let interactionTexts = state.myPetInfo?.levelType.interactionText {
          state.bubbleText = interactionTexts.randomElement() ?? ""
          state.showBubble = true
        }
        
        return .merge(
          .run { send in
            try await Task.sleep(nanoseconds: 300_000_000)
            await send(.hideShineLottieAnimation)
          }.cancellable(id: CancelID.lottieAnimation, cancelInFlight: true),
          
          .run { send in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            await send(.resetInteractionState)
          }.cancellable(id: CancelID.interactionState, cancelInFlight: true)
        )
        
      case .showShineLottieAnimation:
        state.showShineLottieAnimation = true
        return .none
        
      case .hideShineLottieAnimation:
        state.showShineLottieAnimation = false
        return .none
        
      case .resetInteractionState:
        state.isMyPetInteracted = false
        state.showBubble = false
        state.bubbleOffset = .zero
        return .none
        
      case .requestLogin:
        return .send(.delegate(.requestLogin(true)))
        
      case let .hiddenTabBar(isHidden):
        return .send(.delegate(.needToHiddenTabBar(isHidden)))
        
      case let .path(action):
        switch action {
        case .element(id: _, action: .petDetail(.pop)):
          state.path.removeLast()
          return .none
          
        default: return .none
        }
        
      default: return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension MyPetFeature {
  func fetchMyPetInfoEffect(
    _ useCase: CheckPetInfoUseCase
  ) -> Effect<Action> {
    .run { send in
      do {
        let entity = try await useCase.execute()
        await send(.fetchMyPetInfoResult(.success(entity)))
      } catch is CancellationError {
        await send(.fetchMyPetInfoResult(.failure(.taskCancelled)))
      } catch {
        await send(.fetchMyPetInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}

extension MyPetFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case petDetail(MyPetDetailFeature)
  }
}
