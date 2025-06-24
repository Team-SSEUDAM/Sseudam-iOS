//
//  CameraPreviewRepresentable.swift
//  ReportFeature
//
//  Created by 조용인 on 6/25/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import AVFoundation
import SwiftUI

struct CameraPreviewRepresentable: UIViewRepresentable {
  
  @Binding var session: AVCaptureSession?
  
  class VideoPreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { return layer as! AVCaptureVideoPreviewLayer }
  }
  
  func makeUIView(context: Context) -> VideoPreviewView {
    let view = VideoPreviewView()
    view.backgroundColor = .black
    view.videoPreviewLayer.videoGravity = .resizeAspectFill
    view.videoPreviewLayer.cornerRadius = 0
    view.videoPreviewLayer.session = session
    return view
  }
  
  func updateUIView(_ uiView: VideoPreviewView, context: Context) {
    uiView.videoPreviewLayer.session = session
  }
  
}
