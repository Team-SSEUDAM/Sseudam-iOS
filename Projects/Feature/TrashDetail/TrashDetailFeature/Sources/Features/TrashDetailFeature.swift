//
//  TrashDetailFeature.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import Foundation
import ComposableArchitecture
import TrashSpotDomainInterface
import ImageDownloadDomainInterface
import Utility
import UserDefaults
import DesignKit

@Reducer
public struct TrashDetailFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var visited: VisitedFeature.State = .init()
    var isEmptyList: Bool = false
    var trashDetail: TrashSpotDetail? = nil
    var trashImageData: Data? = nil
    var isLoading: Bool = true
    var isFailLoadDetail: Bool = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case visited(VisitedFeature.Action)
    
    case onDisappaer
    case showDetail(id: Int?)
    case showLoading(Bool)
    case noTrashData
    case reportButtonTapped
    
    case setInitVisitedState
    case emptyTrashData(Bool)
    case fetchTrashDetail(id: Int)
    case fetchTrashDetailResult(Result<TrashSpotDetail, NetworkError>)
    
    case fetchTrashImage(imgUrl: String?)
    case storeImageData(data: Data?)
    
    /// 로그인 후 상태 변경하기 위한 action
    case checkLoggedin
    
    case showToastMessage(String?)
    case showAlert(AlertType)
    case visitedComplete(isFirst: Bool)
  }
  
  public enum Delegate: Equatable {
    case reportButtonTapped(TrashSpotDetail?)
    case showToastMessage(String?)
    case showAlert(AlertType)
    /// 방문 완료
    case visitedComplete(isFirst: Bool)
  }
  
  @Dependency(\.FetchTrashSpotDetailUseCase) var fetchTrashSpotDetailUseCase
  @Dependency(\.ImageDownloadUseCase) var imageDownloadUseCase

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.visited, action: \.visited) {
      VisitedFeature()
    }
    
    Reduce { state, action in
      switch action {
      case let .showDetail(id):
        state.isFailLoadDetail = false
        if let id = id {
          return .run { send in
            await send(.showLoading(true))
            await send(.emptyTrashData(false))
            await send(.setInitVisitedState)
            await send(.fetchTrashDetail(id: id))
          }
        } else {
          return .merge([
            .send(.showLoading(false)),
            .send(.emptyTrashData(true))
          ])
        }
      case let .showLoading(isShow):
        state.isLoading = isShow
        return .none
        
      case .setInitVisitedState:
        return .send(.visited(.initialVisitedData))
        
      case let .emptyTrashData(isEmpty):
        state.isEmptyList = isEmpty
        return .none
        
      case .reportButtonTapped:
        return .send(.delegate(.reportButtonTapped(state.trashDetail)))
        
      case let .fetchTrashDetail(id):
        return fetchTrashDetail(id: id)
        
      case let .fetchTrashDetailResult(.success(data)):
        state.trashDetail = data
        return .merge([
          .send(.showLoading(false)),
          .send(.visited(.setTrashSpotInfo(spotId: data.id, point: data.point))),
          .send(.fetchTrashImage(imgUrl: data.imageUrl))
        ])
        
      case let .fetchTrashDetailResult(.failure(error)):
        print(error)
        state.trashDetail = nil
        state.isFailLoadDetail = true
        return .merge([
          .send(.showLoading(false)),
          .send(.visited(.initialVisitedData))
        ])
        
      case let .fetchTrashImage(imgUrl):
        guard let imgUrl = imgUrl else { return .none }
        return .run { send in
          do {
            let data = try await imageDownloadUseCase.execute(imgUrl)
            await send(.storeImageData(data: data))
          } catch let error as ImageDownloadError {
            print(error)
          } catch {
            print(error)
          }
        }
        
      case let .storeImageData(data):
        state.trashImageData = data
        return .none
        
      case .checkLoggedin:
        return checkLoginState()
        
        // MARK: - Send Delegate To Parent Feature
      case let .visitedComplete(isFirst):
        return .send(.delegate(.visitedComplete(isFirst: isFirst)))
        
      case let .showToastMessage(message):
        return .send(.delegate(.showToastMessage(message)))
        
      case let .showAlert(type):
        return .send(.delegate(.showAlert(type)))
        
        // MARK: - Receive VisitedFeature Delegate Action
      case let .visited(.delegate(action)):
        switch action {
        case let .visitedComplete(isFirst):
          return .send(.visitedComplete(isFirst: isFirst))
          
        case let .showToastMessage(message):
          return .send(.showToastMessage(message))
          
        case let .showAlert(type):
          return .send(.showAlert(type))
        }
        
        default: return .none
      }
    }
  }
  
  private func checkLoginState() -> Effect<Action> {
    if UserDefaultsKeys.isLoggedIn ?? false {
      return .merge([
        .send(.visited(.checkEnableVisit)),
        .send(.visited(.checkRemaingTime))
      ])
    } else {
      return .none
    }
  }
  
  private func fetchTrashDetail(id: Int) -> Effect<Action> {
    return .run { send in
      do {
        let data = try await fetchTrashSpotDetailUseCase.execute(id)
        return await(send(.fetchTrashDetailResult(.success(data))))
      } catch {
        return await(send(.fetchTrashDetailResult(.failure(.customError(message: error.localizedDescription)))))
      }
    }
  }
}
