//
//  ImageDownloader.swift
//  NetworkKit
//
//  Created by Jiyeon on 8/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public final class ImageDownloader: ImageDownloaderProtocol {
  public init() {}

  public func downloadData(from url: URL, timeout: TimeInterval = 30.0) async throws -> Data {
    try await withThrowingTaskGroup(of: Data.self) { group in
      group.addTask {
        let request = URLRequest(
          url: url,
          timeoutInterval: timeout
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
          throw ImageDownloadError.unknown
        }

        guard !data.isEmpty else {
          throw ImageDownloadError.emptyData
        }

        return data
      }

      group.addTask {
        try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
        throw ImageDownloadError.timeout(timeout)
      }

      do {
        if let result = try await group.next() {
          group.cancelAll()
          return result
        } else {
          throw ImageDownloadError.unknown
        }
      } catch is CancellationError {
        group.cancelAll()
        throw ImageDownloadError.cancelled
      } catch {
        group.cancelAll()
        throw error
      }
    }
  }
}
