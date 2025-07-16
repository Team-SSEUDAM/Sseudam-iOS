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
    public var myPetInfo: PetInfoEntity?
    public var isLoggedIn: Bool = false

    public var catCards = [
      CatCard(image: "cat1", isLocked: false),
      CatCard(image: "cat2", isLocked: false),
      CatCard(image: nil, isLocked: true),
      CatCard(image: nil, isLocked: true),
      CatCard(image: nil, isLocked: true),
      CatCard(image: nil, isLocked: true)
    ]
    
    public var growthRecords = [
      GrowthRecord(level: "Lv.1", title: "작고 소중한 {{고양이 이름}}", description: "", date: "YY.MM.DD.", stampCount: "0쓰담", isLocked: false),
      GrowthRecord(level: "Lv.2", title: "호기심 가득한 {{고양이 이...", description: "", date: "YY.MM.DD.", stampCount: "20쓰담", isLocked: false),
      GrowthRecord(level: "Lv.3", title: "쑥쑥 자라나는 {{고양이...", description: "", date: nil, stampCount: "110쓰담", isLocked: true),
      GrowthRecord(level: "Lv.4", title: "왕 커서 귀여운{{고양이 이...", description: "", date: nil, stampCount: "N쓰담", isLocked: true),
      GrowthRecord(level: "Special", title: "{{스페셜 문구}} {{고양이...", description: "", date: nil, stampCount: "N쓰담", isLocked: true)
    ]
    
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case path(StackActionOf<Path>)
    case onAppear
    case checkLoggedIn
    case fetchMyPetInfo
    
    case fetchMyPetInfoResult(Result<PetInfoEntity, NetworkError>)
    
    case petNicknameButtonTapped
    case petDetailButtonTapped
    
    case requestLogin
    case hiddenTabBar(Bool)
    case delegate(Delegate)
    
  }
  
  public enum Delegate: Equatable {
    case needToHiddenTabBar(Bool)
    case requestLogin(Bool)
  }
  
  @Dependency(\.CheckPetInfoUseCase) var checkPetInfoUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
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
          return .none
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
