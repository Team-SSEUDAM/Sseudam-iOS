//
//  SuggestionListFeature.swift
//  MyPageFeature
//
//  Created by 조용인 on 8/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility
import ComposableArchitecture
import HistoryDomainInterface
import ImageDownloadDomainInterface

@Reducer
public struct SuggestionListFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var histories: [SuggestionAndReportHistoryEntity]? = nil
    public var suggestionsImages: [Int: Data?] = [:]
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case fetchHistories
    case forceRefreshHistories // 강제 새로고침 액션
    case historiesResponse(Result<[SuggestionAndReportHistoryEntity], NetworkError>)
    
    case fetchTrashImage(imgUrl: String?, id: Int)
    case fetchTrashImageResult(Result<[Int: Data?], ImageDownloadError>) // id: 사진 데이터
    case storeImages(images: [Int: Data?])
  }
  
  @Dependency(\.GetSuggestionAndHistoryUseCase) var getSuggestionAndHistoryUseCase
  @Dependency(\.ImageDownloadUseCase) var imageDownloadUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchHistories:
        /// 이미 불러온 경우 중복 호출 방지 -> refresh 시도 할 때만 재 호출 하기 위함.
        return state.histories == nil ? fetchSuggestions() : .none
        
      case .forceRefreshHistories:
        return fetchSuggestions()
        
      case let .historiesResponse(result):
        switch result {
        case let .success(histories):
          print("Fetched histories: \(histories)")
          state.histories = histories
          return fetchTrashImage(histories)
          
        case let .failure(error):
          state.histories = nil
          print("Error fetching histories: \(error)")
          return .none
        }
      case let .fetchTrashImageResult(result):
        switch result {
        case let .success(imageData):
          print("Fetched image data: \(imageData)")
          state.suggestionsImages = imageData
          return .none
        case let .failure(error):
          print("Error fetching image data: \(error)")
          // 에러 처리 로직 필요
          return .none
        }
      default:
        return .none
      }
    }
  }
}

extension SuggestionListFeature {
  private func fetchSuggestions() -> Effect<Action> {
    return .run { send in
      do {
        let histories = try await getSuggestionAndHistoryUseCase.execute()
        await send(.historiesResponse(.success(histories)))
      } catch let error as NetworkError {
        await send(.historiesResponse(.failure(error)))
      } catch {
        await send(.historiesResponse(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func fetchTrashImage(_ datas: [SuggestionAndReportHistoryEntity]) -> Effect<Action> {
    return .run { send in
      do {
        try await withThrowingTaskGroup(of: (id: Int, data: Data?).self) { group in
          
          for data in datas {
            group.addTask {
              let result = try await imageDownloadUseCase.execute(data.imageUrl, data.id)
              return (id: data.id, data: result)
            }
          }
          
          var results: [Int: Data?] = [:]
          for try await imageData in group {
            results[imageData.id] = imageData.data
          }
          return await send(.fetchTrashImageResult(.success(results)))
        }
      } catch let error as ImageDownloadError {
        await send(.fetchTrashImageResult(.failure(error)))
      } catch {
        await send(.fetchTrashImageResult(.failure(.customImageError(error.localizedDescription))))
      }
    }
  }
}
