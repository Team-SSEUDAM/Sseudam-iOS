//
//  AlertType.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public enum AlertType: Equatable {
  case sample
  
  var title: String {
    switch self {
    case .sample: "sample title"
    }
  }
  
  var message: String? {
    switch self {
    case .sample: "sample message.\nThis is a sample message for the alert type."
    }
  }
  
  var cancel: String {
    switch self {
    case .sample: return "cancel"
    }
  }
  
  var accept: String {
    switch self {
    case .sample: "sample"
    }
  }
}
