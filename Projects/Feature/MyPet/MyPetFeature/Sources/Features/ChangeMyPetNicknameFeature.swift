//
//  ChangeMyPetNicknameFeature.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import Utility
import PetDomainInterface

@Reducer
public struct ChangeMyPetNicknameFeature {
  
  public init() {}
  
  /// 닉네임 유효성 검사 결과
  public enum NameValidationResult: Equatable {
    case valid
    case equalInitName      // 초기 이름과 동일한 경우
    case tooShort           // error1: 0~1자 일때
    case tooLong            // error2: 13자 이상일때
    case startsWithSpace    // error4: 공백으로 시작
    case serverError(String?)        // 서버 통신 과정에서 오류
    case empty              // 초기 상태
    
    /// 에러 메시지 반환
    var message: String {
      switch self {
      case .valid:
        return "사용 가능한 고양이 이름이에요."
      case .equalInitName:
        return ""
      case .tooShort:
        return "고양이 이름은 2자 이상 입력해주세요."
      case .tooLong:
        return "고양이 이름은 12자 이하로 입력해주세요."
      case .startsWithSpace:
        return "고양이 이름은 공백으로 시작할 수 없어요."
      case let .serverError(errorMessage):
        return errorMessage ?? self.defaultErrorMessage
      case .empty:
        return "2~12자까지 입력할 수 있어요."
      }
    }
    
    var defaultErrorMessage: String { return "서버 통신에 실패했어요. 잠시 후 다시 시도해주세요." }
    
    /// TextField 상태 반환
    var textFieldState: CustomTextFieldState {
      switch self {
      case .valid:
        return .accent
      case .tooShort, .tooLong, .startsWithSpace, .serverError:
        return .error
      case .empty, .equalInitName:
        return .normal
      }
    }
    
    /// 버튼 활성화 여부
    var isButtonEnabled: Bool {
      return self == .valid
    }
  }
  
  @ObservableState
  public struct State: Equatable {
    public let initName: String
    public var name: String
    public var validationResult: NameValidationResult = .empty
    public var isFocused: Bool = false
    public var isLoading: Bool = false
    public var buttonState: PrimaryButtonState = .disabled
    
    public init(
      name: String? = nil
    ) {
      guard let name = name, !name.isEmpty else {
        self.initName = ""
        self.name = ""
        return
      }
      
      let realName = name.split(separator: " ").last.map { String($0) } ?? ""
      
      self.initName = realName
      self.name = initName
    }
    
    /// 현재 텍스트필드 상태
    public var textFieldState: CustomTextFieldState {
      validationResult.textFieldState
    }
    
    /// 에러 메시지
    public var errorMessage: String {
      validationResult.message
    }
    
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case backButtonTapped
    case pop
    case focusChanged(Bool)
    case delegate(Delegate)
    
    case changeNicknameButtonTapped
    case changeNicknameButtonTappedResult(Result<String, NetworkError>)
    
    public enum Delegate: Equatable {
      case didChangeNickname
    }
  }
  
  @Dependency(\.ChangePetNicknameUseCase) var changePetNicknameUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.name):
        state.validationResult = validateNameInput(
          state.name,
          initName: state.initName
        )
        state.buttonState = state.validationResult.isButtonEnabled
        ? .normal
        : .disabled
        return .none
        
      case let .focusChanged(isFocused):
        state.isFocused = isFocused
        return .none
        
      case .changeNicknameButtonTapped:
        state.isLoading = true
        return changeNickname(name: state.name)

      case let .changeNicknameButtonTappedResult(result):
        state.isLoading = false
        switch result {
        case .success:
          return .run { send in
            await send(.delegate(.didChangeNickname))
            await send(.pop)
          }
        case let .failure(error):
          state.validationResult = .serverError(error.errorDescription)
          state.buttonState = .disabled
          return .none
        }
      case .backButtonTapped:
        return .send(.pop)
      default:
        return .none
      }
    }
  }
}

extension ChangeMyPetNicknameFeature {
  
  private func changeNickname(
    name: String
  ) -> Effect<Action> {
    return .run { send in
      do {
        try await changePetNicknameUseCase.execute(name)
        await send(.changeNicknameButtonTappedResult(.success(name)))
      } catch let error as NetworkError {
        await send(.changeNicknameButtonTappedResult(.failure(error)))
      } catch {
        await send(.changeNicknameButtonTappedResult(.failure(NetworkError.customError(message: error.localizedDescription))))
      }
    }
  }
  
  /// 닉네임 유효성 검사 로직 (클라이언트 검증)
  /// 우선순위: error1(길이 부족) > error2(길이 초과) > error3(특수문자/이모지) > error4(공백으로 시작)
  private func validateNameInput(
    _ name: String,
    initName: String?
  ) -> NameValidationResult {
    if name == initName { return .equalInitName }
    /// 빈 문자열
    if name.isEmpty { return .empty}
    /// error4: 공백으로 시작 (우선순위 4)
    if name.hasPrefix(" ") { return .startsWithSpace }
    /// error1: 0~1자 (우선순위 1)
    if name.count < 2 { return .tooShort }
    /// error2: 13자 이상 (우선순위 2)
    if name.count > 12 { return .tooLong }
    /// 모든 검사 통과
    return .valid
  }
}
