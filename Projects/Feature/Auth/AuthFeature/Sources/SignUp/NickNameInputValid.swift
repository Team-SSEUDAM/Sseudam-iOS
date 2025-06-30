//
//  NickNameInputValid.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/24/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import DesignKit

public enum NickNameInputValid: Equatable {
  case valid
  case tooShort
  case tooLong
  case none
  case duplicate
  case invalid

  public var text: String {
    switch self {
    case .valid: return "2~12자까지 입력할 수 있어요."
    case .tooShort: return "닉네임은 2자 이상 입력해주세요."
    case .tooLong: return "닉네임은 12자 이하로 입력해주세요."
    case .none: return "2~12자까지 입력할 수 있어요."
    case .duplicate: return "이미 사용중인 닉네임이에요."
    case .invalid: return "특수문자는 사용이 불가능해요."
    }
  }
  
  public var isValid: Bool {
    self == .valid
  }
  
  public var textFieldState: CustomTextFieldState {
    switch self {
    case .valid:
      return .accent
    case .tooShort, .tooLong, .duplicate, .invalid:
      return .error
    case .none:
      return .accent
    }
  }
  
}
