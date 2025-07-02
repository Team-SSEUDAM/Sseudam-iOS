//
//  CameraPickerRepresentable.swift
//  DesignKit
//
//  Created by 조용인 on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

// MARK: - Camera Picker UIKit Representable
public struct CameraPickerRepresentable: UIViewControllerRepresentable {
  public let onImagePicked: (UIImage) -> Void
  public let onCancel: () -> Void
  
  public init (
    onImagePicked: @escaping (UIImage) -> Void,
    onCancel: @escaping () -> Void
  ) {
    self.onImagePicked = onImagePicked
    self.onCancel = onCancel
  }
  
  public func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.cameraCaptureMode = .photo
    picker.cameraDevice = .rear
    picker.delegate = context.coordinator
    return picker
  }
  
  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    public let parent: CameraPickerRepresentable
    
    public init(_ parent: CameraPickerRepresentable) {
      self.parent = parent
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let originalImage = info[.originalImage] as? UIImage {
        parent.onImagePicked(originalImage)
      }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.onCancel()
    }
  }
}
