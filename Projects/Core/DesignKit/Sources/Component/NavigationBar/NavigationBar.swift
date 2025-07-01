//
//  NavigationBar.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct NavigationBar<BackContent: View, CloseContent: View>: View {
  
  public let backContent: (() -> BackContent)
  public let closeContent: (() -> CloseContent)
  public let title: String?
  private var isBackToSwipeEnabled: Bool = true
  
  public init(
    @ViewBuilder backContent: @escaping () -> BackContent = { Spacer().frame(width: .Number48, height: .Number48) },
    title: String? = nil,
    @ViewBuilder closeContent: @escaping () -> CloseContent = { Spacer().frame(width: .Number48, height: .Number48) }
  ) {
    self.backContent = backContent
    self.title = title
    self.closeContent = closeContent
  }
  
  public var body: some View {
    if isBackToSwipeEnabled { NavigationGestureSupportView().frame(width: .Number0, height: .Number0) }
    content
  }
  
  @ViewBuilder
  private var content: some View {
    HStack {
      backContent().padding(.leading, .Number4)
      Spacer()
      if let title = title {
        Text(title)
          .font(FontSet.Title.title3)
          .foregroundStyle(ColorSet.Text.Primary)
      }
      Spacer()
      closeContent().padding(.trailing, .Number4)
    }
    .background(ColorSet.Background.Primary)
  }
}

extension NavigationBar {
  public func blockBackToSwipe() -> Self {
    var view = self
    view.isBackToSwipeEnabled = false
    return view
  }
}

public struct NavigationGestureSupportView: UIViewControllerRepresentable {
  
  public init() { }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    Task { @MainActor in
      if let navigationController = controller.navigationController {
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
        navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
      }
    }
    return controller
  }

  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  public class Coordinator: NSObject, UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      true
    }
  }
}
