//
//  WebView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 8/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  
  var url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    
    let webview = WKWebView()
    webview.navigationDelegate = context.coordinator
    webview.overrideUserInterfaceStyle = .light
    return webview
  }
  
  func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
    uiView.load(URLRequest(url: url))
  }
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
    uiView.stopLoading()
    uiView.navigationDelegate = nil
    uiView.uiDelegate = nil
    uiView.removeFromSuperview()
  }
  
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var webView: WebView
    init(_ webView: WebView) {
      self.webView = webView
    }
  }
}
