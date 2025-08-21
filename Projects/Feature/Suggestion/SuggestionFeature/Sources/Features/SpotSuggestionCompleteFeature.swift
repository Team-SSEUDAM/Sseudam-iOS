//
//  SpotSuggestionCompleteFeature.swift
//  SuggestionFeature
//
//  Created by 조용인 on 8/21/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import DesignKit
import AttendanceDomainInterface
import PetDomainInterface
import Utility
import DotLottie

@Reducer
public struct SpotSuggestionCompleteFeature {
  
  public init() { }
  
  @ObservableState
  public struct State: Equatable {
    public var petInfo: PetInfoEntity? = nil
    public var sseudamPoint: SseudamPoint = .visit
    public var toastMessage: AttributedString? = nil
    public var showLevelBar: Bool = false
    public var startLevelAnimation: Bool = false
    public init() { }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    
    case fetchPetInfo
    case fetchPetInfoResult(Result<PetInfoEntity, NetworkError>)
    
    case showToastMessage(AttributedString?)
    case dismissToastMessage
    case delegate(Delegate)
    
    // Delegate actions
    public enum Delegate: Equatable {
      case done
    }
  }
  
  @Dependency(\.CheckPetInfoUseCase) var checkPetInfoUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchPetInfo)
        
      case .fetchPetInfo:
        return fetchPetInfo()
        
      case let .fetchPetInfoResult(.success(entity)):
        state.petInfo = entity
        state.showLevelBar = true
        state.startLevelAnimation = true
        return sseudamToast(sseudam: state.sseudamPoint)
        
      case let .fetchPetInfoResult(.failure(error)):
        return sseudamToast(error: error.localizedDescription)
        
      case let .showToastMessage(msg):
        state.toastMessage = msg
        return .none
        
      case .dismissToastMessage:
        state.toastMessage = nil
        return .none
        
      default:
        return .none
      }
    }
  }
}

extension SpotSuggestionCompleteFeature {
  
  private func fetchPetInfo() -> Effect<Action> {
    return .run { send in
      do {
        let data = try await checkPetInfoUseCase.execute()
        await send(.fetchPetInfoResult(.success(data)))
      } catch let error as NetworkError {
        await send(.fetchPetInfoResult(.failure(error)))
      } catch {
        await send(.fetchPetInfoResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func sseudamToast(sseudam: SseudamPoint? = nil, error: String? = nil) -> Effect<Action> {
    if let sseudam = sseudam {
      let point = sseudam.sseudamText
      var attributed: AttributedString {
        var sseudam = AttributedString(point)
        var text = AttributedString("이 적립됐어요!")
        sseudam.foregroundColor = ColorSet.Text.InverseAccent
        text.foregroundColor = ColorSet.Text.Inverse
        sseudam.append(text)
        return sseudam
      }
      return .send(.showToastMessage(attributed))
    } else if let errorMessage = error {
      var attributed: AttributedString = {
        var attri = AttributedString(errorMessage)
        attri.foregroundColor = ColorSet.Text.Error
        return attri
      }()
      return .send(.showToastMessage(attributed))
    } else {
      return .none
    }
  }
}
