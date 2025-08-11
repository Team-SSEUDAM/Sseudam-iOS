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
import SuggestionDomainInterface
import ImageDownloadDomainInterface

@Reducer
public struct SuggestionListFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    
    public var suggestions: [SuggestionListEntity]? = nil
    public var suggestionsImages: [Int: Data?] = [:]
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    case fetchSuggestions
    case forceRefreshSuggestions // 강제 새로고침 액션
    case suggestionsResponse(Result<[SuggestionListEntity], NetworkError>)
    
    case fetchTrashImage(imgUrl: String?, id: Int)
    case fetchTrashImageResult(Result<[Int: Data?], ImageDownloadError>) // id: 사진 데이터
    case storeImages(images: [Int: Data?])
  }
  
  @Dependency(\.GetSuggestionListUseCase) var getSuggestionListUseCase
  @Dependency(\.ImageDownloadUseCase) var imageDownloadUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .fetchSuggestions:
        /// 이미 불러온 경우 중복 호출 방지 -> refresh 시도 할 때만 재 호출 하기 위함.
        return state.suggestions == nil ? fetchSuggestions() : .none
        
      case .forceRefreshSuggestions:
        return fetchSuggestions()
        
      case let .suggestionsResponse(result):
        switch result {
        case let .success(suggestions):
          print("Fetched suggestions: \(suggestions)")
          state.suggestions = suggestions
          return fetchTrashImage(suggestions)
          
        case let .failure(error):
          state.suggestions = nil
          print("Error fetching suggestions: \(error)")
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
        let suggestions = try await getSuggestionListUseCase.execute()
        await send(.suggestionsResponse(.success(suggestions)))
      } catch let error as NetworkError {
        await send(.suggestionsResponse(.failure(error)))
      } catch {
        await send(.suggestionsResponse(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  private func fetchTrashImage(_ datas: [SuggestionListEntity]) -> Effect<Action> {
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
