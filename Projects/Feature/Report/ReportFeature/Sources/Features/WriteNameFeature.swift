//
//  WriteNameFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import Utility

@Reducer
public struct WriteNameFeature {
  
  public init() {}
  
  /// 닉네임 유효성 검사 결과
  public enum NameValidationResult: Equatable {
    case valid
    case tooShort           // error1: 0~1자 일때
    case tooLong            // error2: 13자 이상일때
    case containsSpecialChar // error3: 특수문자 + 이모지 포함
    case startsWithSpace    // error4: 공백으로 시작
    case alreadyUsing        // 이미 사용중인 쓰레기통 이름일 때
    case serverError        // 서버 통신 과정에서 오류
    case checking           // 서버 검증 중
    case empty              // 초기 상태
    
    /// 에러 메시지 반환
    var message: String {
      switch self {
      case .valid:
        return "사용 가능한 쓰레기통 이름이에요."
      case .tooShort:
        return "쓰레기통 이름은 2자 이상 입력해주세요."
      case .tooLong:
        return "쓰레기통 이름은 12자 이하로 입력해주세요."
      case .containsSpecialChar:
        return "쓰레기통 이름은 특수문자나 이모지 사용이 불가능해요."
      case .startsWithSpace:
        return "쓰레기통 이름은 공백으로 시작할 수 없어요."
      case .alreadyUsing:
        return "이미 사용중인 쓰레기통 이름이에요."
      case .serverError:
        return "서버와의 통신에 문제가 발생했어요. 잠시 후 다시 시도해주세요."
      case .checking:
        return "쓰레기통 이름을 확인하고 있어요..."
      case .empty:
        return "2~12자까지 입력할 수 있어요."
      }
    }
    
    /// TextField 상태 반환
    var textFieldState: CustomTextFieldState {
      switch self {
      case .valid:
        return .accent
      case .tooShort, .tooLong, .containsSpecialChar, .startsWithSpace, .alreadyUsing, .serverError:
        return .error
      case .checking:
        return .accent
      case .empty:
        return .normal
      }
    }
    
    /// 버튼 활성화 여부
    var isButtonEnabled: Bool {
      return self == .valid
    }
    
    /// 로딩 상태 여부
    var isLoading: Bool {
      return self == .checking
    }
  }
  
  @ObservableState
  public struct State: Equatable {
    public var name: String = ""
    public var validationResult: NameValidationResult = .empty
    public var isFocused: Bool = false
    
    public init() {}
    
    /// 현재 텍스트필드 상태
    public var textFieldState: CustomTextFieldState {
      validationResult.textFieldState
    }
    
    /// 버튼 활성화 여부
    public var isButtonEnabled: Bool {
      validationResult.isButtonEnabled
    }
    
    /// 에러 메시지
    public var errorMessage: String {
      validationResult.message
    }
    
    /// 로딩 상태
    public var isLoading: Bool {
      validationResult.isLoading
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case focusChanged(Bool)
    case delegate(Delegate)
    case validateNameFromServer
    case validateNameResult(Result<Bool, NetworkError>)
    
    public enum Delegate: Equatable {
      case localValidationCompleted(isValid: Bool, name: String)
      case serverValidationCompleted(isValid: Bool, name: String)
    }
  }
  
  @Dependency(\.SpotNameValidateUseCase) var spotNameValidateUseCase
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.name): /// 이름이 바뀔 때 는, local 검증을 수행
        if state.validationResult == .checking { return .none }
        let previousResult = state.validationResult
        state.validationResult = validateNameInput(state.name)
        if previousResult == state.validationResult { return .none }
        return .send(.delegate(.localValidationCompleted(isValid: state.isButtonEnabled, name: state.name)))
      
      case let .focusChanged(isFocused):
        state.isFocused = isFocused
        return .none
        
      case .validateNameFromServer:
        return spotNameValidateEffect(state.name)
        
      case let .validateNameResult(result):
        switch result {
        case let .success(isValid):
          state.validationResult = isValid ? .valid : .alreadyUsing
          return .send(.delegate(.serverValidationCompleted(isValid: isValid, name: state.name)))
          
        case .failure:
          state.validationResult = .serverError
          return .send(.delegate(.serverValidationCompleted(isValid: false, name: "")))
        }
        
      default:
        return .none
      }
    }
  }
}

extension WriteNameFeature {
  
  private func spotNameValidateEffect(
    _ name: String
  ) -> Effect<Action> {
    return .run { send in
      do {
        let isValid = try await spotNameValidateUseCase.execute(name)
        await send(.validateNameResult(.success(isValid)))
      } catch is CancellationError {
        await send(.validateNameResult(.failure(.taskCancelled)))
      } catch {
        await send(.validateNameResult(.failure(.customError(message: error.localizedDescription))))
      }
    }
  }
  
  /// 닉네임 유효성 검사 로직 (클라이언트 검증)
  /// 우선순위: error1(길이 부족) > error2(길이 초과) > error3(특수문자/이모지) > error4(공백으로 시작)
  private func validateNameInput(_ name: String) -> NameValidationResult {
    /// 빈 문자열
    if name.isEmpty { return .empty}
    /// error4: 공백으로 시작 (우선순위 4)
    if name.hasPrefix(" ") { return .startsWithSpace }
    /// error1: 0~1자 (우선순위 1)
    if name.count < 2 { return .tooShort }
    /// error2: 13자 이상 (우선순위 2)
    if name.count > 12 { return .tooLong }
    /// error3: 특수문자 + 이모지 포함 (우선순위 3)
    if containsInvalidCharacters(name) { return .containsSpecialChar }
    /// 모든 검사 통과
    return .valid
  }
  
  /// 특수문자 및 이모지 포함 여부 검사
  private func containsInvalidCharacters(_ text: String) -> Bool {
    // 허용되는 문자: 한글, 영문, 숫자, 공백
    let allowedCharacterSet = CharacterSet.alphanumerics
      .union(.whitespacesAndNewlines)
      .union(CharacterSet(charactersIn: "가-힣ㄱ-ㅎㅏ-ㅣ"))
    
    // 입력된 텍스트에서 허용되지 않는 문자가 있는지 확인
    return text.unicodeScalars.contains { scalar in
      !allowedCharacterSet.contains(scalar)
    }
  }
}
