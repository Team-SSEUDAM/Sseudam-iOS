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
      
      // 1) 보안 범위 접근 시작
      guard url.startAccessingSecurityScopedResource() else {
        print("[DocumentPicker] 보안 범위 접근 불가")
        parent.onCancel()
        return
      }
      defer {
        url.stopAccessingSecurityScopedResource()
      }
      
      do {
        let data = try Data(contentsOf: url)
        if let image = UIImage(data: data) {
          parent.onImagePicked(image)
        } else {
          print("[DocumentPicker] 이미지 디코딩 실패")
          parent.onCancel()
        }
      } catch {
        print("[DocumentPicker] 데이터 읽기 오류:", error)
        parent.onCancel()
      }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      parent.onCancel()
    }
  }
}
