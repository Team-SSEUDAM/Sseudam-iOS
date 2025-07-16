//
//  GrowthRecord.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public struct GrowthRecord: Identifiable {
  public let id = UUID()
  public let level: String
  public let title: String
  public let description: String
  public let date: String
  public let stampCount: String
  public let isLocked: Bool
}
