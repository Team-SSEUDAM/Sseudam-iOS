//
//  SuggestionEndpoint.swift
//
//  Suggestion
//
//  Created by yongin
//

import Foundation
import NetworkKit
import UserDefaults
import SuggestionDomainInterface

public enum SuggestionEndpoint: Sendable {
  
  public static func postSpotSuggestion(
    body: SpotSuggestionBody
  ) -> Endpoint<SpotSuggestionDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .post,
      path: "/suggestions",
      parameters: .body(body)
    )
  }
  
  public static func getSpotNameValidation(
    body: SpotNameValidateBody
  ) -> Endpoint<SpotNameValidationDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .post,
      path: "/suggestions/validate",
      parameters: .body(body)
    )
  }
  
  public static func getSuggestionList() -> Endpoint<SpotSuggestionsDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .get,
      path: "/suggestions",
      parameters: nil
    )
  }
  
  public static func getSuggestionDetail(suggestionID: Int, body: SuggestionDetailBody) -> Endpoint<SuggestionDetailDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .get,
      path: "/suggestions/\(suggestionID)",
      parameters: .query(body)
    )
  }
  
  
}
