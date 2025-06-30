//
//  UploadSpotImageInput.swift
//  SuggestionDomainInterface
//
//  Created by 조용인 on 6/29/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import Utility

public struct UploadSpotImageInput: Codable, Equatable {
  public let image: Data
  public let presignedUrl: String
  
  public init(
    image: UIImage,
    presignedUrl: String
  ) {
    self.image = image.jpegData(compressionQuality: 0.8) ?? Data()
    self.presignedUrl = presignedUrl
  }
}
