//
//  PetEndpoint.swift
//  PetDataInterface
//
//  Created by 조용인 on 7/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import NetworkKit
import UserDefaults
import PetDomainInterface

public enum PetEndpoint: Sendable {
  
  public static func getPetInfo() -> Endpoint<PetInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .get,
      path: "/pets",
      parameters: .none
    )
  }
  
  public static func getPetSeasonInfo() -> Endpoint<PetSeasonInfoDTO> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .get,
      path: "/pets/season",
      parameters: .none
    )
  }
  
  public static func putPetNickname(_ nickname: String) -> Endpoint<EmptyResponse> {
    return Endpoint(
      headers: .authorization(UserDefaultsKeys.accessToken),
      method: .put,
      path: "/pets/name",
      parameters: .body(["nickname": nickname])
    )
  }
}
