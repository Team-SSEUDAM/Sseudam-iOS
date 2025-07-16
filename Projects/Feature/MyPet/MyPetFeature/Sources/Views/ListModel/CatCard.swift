//
//  CatCardModel.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct CatCard: Identifiable {
  public let id = UUID()
  public let image: String? // nil이면 잠긴 상태
  public let isLocked: Bool
}
