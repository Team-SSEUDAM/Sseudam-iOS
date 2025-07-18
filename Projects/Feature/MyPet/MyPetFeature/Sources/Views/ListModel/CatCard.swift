//
//  CatCardModel.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct CatCard: Identifiable, Equatable {
  public let id = UUID()
  public let isLocked: Bool
  public let imageURL: String
}
