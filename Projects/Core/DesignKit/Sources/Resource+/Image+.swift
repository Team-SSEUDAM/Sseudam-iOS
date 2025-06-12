//
//  Image+.swift
//  DesignKit
//
//  Created by 조용인 on 6/9/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public enum ImageSet: String {
  case propertyLeft = "Property=left"
  case add = "add"
  case addSpot = "addSpot"
  case arrowCircleUp = "arrow_circle_up"
  case cancel = "cancel"
  case chevronRight = "chevron_right"
  case close = "close"
  case delete = "delete"
  case deleteFill = "delete_fill"
  case edit = "edit"
  case home = "home"
  case homeFilled = "home__filled"
  case info = "info"
  case interests = "interests"
  case lock = "lock"
  case myLocation = "my_location"
  case person = "person"
  case personFilled = "person__filled"
  case recycle = "recycle"
  case replay = "replay"
  case search = "search"
  case sentimentDissatisfied = "sentiment_dissatisfied"
  case settings = "settings"
  
  public var swiftUIImage: DesignKitImages { DesignKitImages(name: self.rawValue) }
}
