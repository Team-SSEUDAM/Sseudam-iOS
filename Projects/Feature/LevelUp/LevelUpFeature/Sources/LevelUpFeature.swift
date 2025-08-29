//
//  LevelUpFeature.swift
//
//  LevelUp
//
//  Created by Jiyeon
//

import ComposableArchitecture
import PetDomainInterface
import DesignKit
import DotLottie
import UserDefaults

@Reducer
public struct LevelUpFeature {
  
  public init() {
    
  }
  
  @ObservableState
  public struct State: Equatable {
    let petInfo: PetInfoEntity
    let catLevel: CatLevel
    let animationState: AnimationState = .init()
    var showConfetti: Bool = false
    var showButton: Bool = false
    
    public init(petInfo: PetInfoEntity) {
      self.catLevel = petInfo.levelType
      self.petInfo = petInfo
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case startAnimation
    case confirmButtonTapped
    case animation(LevelUpAnimationAction)
    
    case dismiss
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case dismiss
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.startAnimation)
        
      case .startAnimation:
        return startAnimaion()
        
      case let .animation(animation):
        switch animation {
        case .confetti:
          state.animationState.confetti.play()
          state.showConfetti = true
          return .none
          
        case .showButton:
          state.showButton = true
          return .none
        }
        
      case .confirmButtonTapped:
        UserDefaultsKeys.current_catlevel = state.catLevel.rawInt
        UserDefaultsKeys.isNeedLevelUp = false
        return .send(.dismiss)
        
      case .dismiss:
        return .send(.delegate(.dismiss))
        
        default: return .none
      }
    }
  }
  
  private func startAnimaion() -> Effect<Action> {
    return .run { send in
      try await Task.sleep(for: .seconds(0.4))
      await send(.animation(.confetti))
      
      try await Task.sleep(for: .seconds(0.8))
      await send(.animation(.showButton))
    }
  }
}


extension LevelUpFeature {
  public enum LevelUpAnimationAction: Equatable {
    case confetti
    case showButton
  }
  
  public struct AnimationState: Equatable {
    var confetti = DotLottieAnimation(
      fileName: LottieSet.confetti.name,
      config: AnimationConfig(autoplay: false, loop: false)
    )
    
    public static func == (lhs: LevelUpFeature.AnimationState, rhs: LevelUpFeature.AnimationState) -> Bool {
      return true
    }
  }
}
