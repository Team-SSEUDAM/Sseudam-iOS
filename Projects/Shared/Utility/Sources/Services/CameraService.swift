//
//  CameraService.swift
//  Utility
//
//  Created by 조용인 on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//
// CameraService.swift
// CameraService.swift

import AVFoundation

public enum CameraServiceError: Error {
  case permissionDenied
  case noDevice
  case captureFailed
}

public struct CameraService: Equatable {
  public var session: AVCaptureSession = AVCaptureSession()
  public let input: AVCaptureDeviceInput
  public let output: AVCapturePhotoOutput = AVCapturePhotoOutput()
  
  public init() {
    do {
      guard let device = AVCaptureDevice.default(for: .video)
      else { throw CameraServiceError.noDevice }
      self.input = try AVCaptureDeviceInput(device: device)
    } catch {
      fatalError("Failed to create AVCaptureDeviceInput: \(error)")
    }
  }
  
  public func setUpCamera() async throws {
    try await checkPermission()
    try startCapture()
  }
  
  private func startCapture() throws {
    if session.canAddInput(input) { session.addInput(input) }
    if session.canAddOutput(output) { session.addOutput(output) }
    session.startRunning()
  }
  
  private func checkPermission() async throws {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized: return
    case .notDetermined:
      let granted = await withCheckedContinuation { continuation in
        AVCaptureDevice.requestAccess(for: .video) { continuation.resume(returning: $0) }
      }
      guard granted else { throw CameraServiceError.permissionDenied }
    default: throw CameraServiceError.permissionDenied
    }
  }

}
