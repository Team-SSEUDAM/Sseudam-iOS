//
//  ImageDownloaderProtocol.swift
//  NetworkKit
//
//  Created by Jiyeon on 8/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public protocol ImageDownloaderProtocol {
  func downloadData(from url: URL, timeout: TimeInterval) async throws -> Data
}
