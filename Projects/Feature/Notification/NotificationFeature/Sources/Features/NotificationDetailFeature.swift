//
//  NotificationDetailFeature.swift
//  NotificationFeature
//
//  Created by Jiyeon on 10/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import ComposableArchitecture
import NotificationDomainInterface
import SuggestionDomainInterface
import ReportDomainInterface
import TrashSpotDomainInterface
import UserDefaults
import Utility

@Reducer
public struct NotificationDetailFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable { }
  
  public enum Action: Equatable {
    case handleTappedItem(NotificationEntity)
    
    case fetchSuggestionRejectReason(id: Int)
    case fetchSuggestionRejectReasonResult(Result<String, NetworkError>)
    
    case fetchReportRejectReason(id: Int)
    case fetchReportRejectReasonResult(Result<String, NetworkError>)
    
    case fetchTrashSpotDetail(id: Int)
    case fetchTrashSpotDetailResult(Result<TrashSpotDetail, NetworkError>)
    
    case delegate(Delegate)
  }
  
  public enum Delegate: Equatable {
    case showThrowTrash(data: TrashSpotDetail)
    case moveAcceptList
    case showRefuseAlert(reason: String)
    case showToastMessage(String?)
  }
  
  @Dependency(\.SuggestionDetailUseCase) private var suggestionDetailUseCase
  @Dependency(\.ReportDetailUseCase) private var reportdetailUseCase
  @Dependency(\.FetchTrashSpotDetailUseCase) private var trashSpotDetailUseCase

  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .handleTappedItem(data):
        return handleTappedItem(data)
        
      case let .fetchSuggestionRejectReason(suggestionId):
        return fetchSuggestionRejectReason(suggestionId: suggestionId)
        
      case let .fetchSuggestionRejectReasonResult(.success(reason)):
        return .send(.delegate(.showRefuseAlert(reason: reason)))
      
      case let .fetchSuggestionRejectReasonResult(.failure(error)):
        return .send(.delegate(.showToastMessage(error.localizedDescription)))
        
      case let .fetchReportRejectReason(reportId):
        return fetchReportRejectReason(reportId: reportId)
        
      case let .fetchReportRejectReasonResult(.success(reason)):
        return .send(.delegate(.showRefuseAlert(reason: reason)))
        
      case let .fetchReportRejectReasonResult(.failure(error)):
        return .send(.delegate(.showToastMessage(error.localizedDescription)))
        
      case let .fetchTrashSpotDetail(id):
        return fetchTrashSpotDetail(id: id)
        
      case let .fetchTrashSpotDetailResult(.success(data)):
        return .send(.delegate(.showThrowTrash(data: data)))
        
      case let .fetchTrashSpotDetailResult(.failure(error)):
        return .send(.delegate(.showToastMessage(error.localizedDescription)))
        
      case .delegate: return .none
      }
    }
  }
  
  private func handleTappedItem(_ entity: NotificationEntity) -> Effect<Action> {
    switch entity.type {
    case .visitedSpot:
      return .send(.fetchTrashSpotDetail(id: entity.parameterValue))
    case .approveSuggestion, .approveReport:
      return .send(.delegate(.moveAcceptList))
    case .rejectSuggestion:
      return .send(.fetchSuggestionRejectReason(id: entity.parameterValue))
    case .rejectReport:
      return .send(.fetchReportRejectReason(id: entity.parameterValue))
    default:
      return .none
    }
  }
  
  private func fetchSuggestionRejectReason(suggestionId: Int) -> Effect<Action> {
    guard let userId = UserDefaultsKeys.userId else { return .none }
    return .run { send in
      do {
        let data = try await suggestionDetailUseCase.execute(userId, suggestionId)
        await send(.fetchSuggestionRejectReasonResult(.success(data.rejectReason)))
      } catch let error as NetworkError {
        await send(.fetchSuggestionRejectReasonResult(.failure(error)))
      } catch {
        await send(.fetchSuggestionRejectReasonResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func fetchReportRejectReason(reportId: Int) -> Effect<Action> {
    guard let userId = UserDefaultsKeys.userId else { return .none }
    return .run { send in
      do {
        let data = try await reportdetailUseCase.execute(userId, reportId)
        await send(.fetchReportRejectReasonResult(.success(data.rejectReason)))
      } catch let error as NetworkError {
        await send(.fetchReportRejectReasonResult(.failure(error)))
      } catch {
        await send(.fetchReportRejectReasonResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func fetchTrashSpotDetail(id: Int) -> Effect<Action> {
    return .run { send in
      do {
        let data = try await trashSpotDetailUseCase.execute(id)
        await send(.fetchTrashSpotDetailResult(.success(data)))
      } catch let error as NetworkError {
        await send(.fetchTrashSpotDetailResult(.failure(error)))
      } catch {
        await send(.fetchTrashSpotDetailResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
}
