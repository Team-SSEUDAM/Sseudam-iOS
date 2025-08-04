//
//  ImageDownloader.swift
//  NetworkKit
//
//  Created by Jiyeon on 8/2/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import Utility

public struct ImageDownloader: ImageDownloaderProtocol {
  
  private let session: URLSession
  public init(
    session: URLSession = .shared
  ) {
    self.session = session
  }

  public func downloadData(from url: URL, timeout: TimeInterval = 30.0) async throws -> Data {
    try await withThrowingTaskGroup(of: Data.self) { group in
      group.addTask {
        let request = URLRequest(
          url: url,
          timeoutInterval: timeout
        )

        let (data, response) = try await self.session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
          throw handleDownloadError(ImageDownloadError.unknown, url: url)
        }

        guard !data.isEmpty else {
          throw handleDownloadError(ImageDownloadError.emptyData, url: url)
        }

        return data
      }

      group.addTask {
        try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
        throw handleDownloadError(ImageDownloadError.timeout(timeout), url: url)
      }

      do {
        if let result = try await group.next() {
          group.cancelAll()
          return result
        } else {
          throw handleDownloadError(ImageDownloadError.unknown, url: url)
        }
      } catch is CancellationError {
        group.cancelAll()
        throw handleDownloadError(ImageDownloadError.cancelled, url: url)
      } catch {
        group.cancelAll()
        throw handleDownloadError(error, url: url)
      }
    }
  }
  
  private func handleDownloadError(_ error: Error, url: URL) -> Error {
    var description: String = error.localizedDescription
    if let error = error as? ImageDownloadError {
      description = error.errorDescription
    }
    print("""
    ======== ❌ Fail Download Image ========
    ✔️ message: \(description)
    ✔️ url: \(url)
    ========================================
    """)
    return error
  }
}
