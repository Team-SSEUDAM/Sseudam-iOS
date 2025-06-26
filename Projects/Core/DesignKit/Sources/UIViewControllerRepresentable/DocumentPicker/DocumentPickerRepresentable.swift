//
//  DocumentPickerRepresentable.swift
//  DesignKit
//
//  Created by 조용인 on 6/26/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct DocumentPickerRepresentable: UIViewControllerRepresentable {
  private let onImagePicked: (UIImage) -> Void
  private let onCancel: () -> Void
  
  public init(
    onImagePicked: @escaping (UIImage) -> Void,
    onCancel: @escaping () -> Void
  ) {
    self.onImagePicked = onImagePicked
    self.onCancel = onCancel
  }
  
  public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
    picker.delegate = context.coordinator
    picker.allowsMultipleSelection = false
    return picker
  }
  
  public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, UIDocumentPickerDelegate {
    public let parent: DocumentPickerRepresentable
    
    public init(_ parent: DocumentPickerRepresentable) {
      self.parent = parent
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      guard let url = urls.first else { return }
      
      if let image = UIImage(contentsOfFile: url.path) {
        parent.onImagePicked(image)
      }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      parent.onCancel()
    }
  }
}
