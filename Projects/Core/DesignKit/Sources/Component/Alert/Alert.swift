//
//  Alert.swift
//  DesignKit
//
//  Created by 조용인 on 6/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct Alert: View {
  
  private let type: AlertType
  private let isErrorType: Bool
  private let isSingleButton: Bool
  private let closeAction: @Sendable () -> Void
  private let acceptAction: @Sendable () -> Void
  
  public init(
    type: AlertType,
    isErrorType: Bool = false,
    isSingleButton: Bool = false,
    closeAction: @escaping @Sendable () -> Void,
    acceptAction: @escaping @Sendable () -> Void
  ) {
    self.type = type
    self.isErrorType = isErrorType
    self.isSingleButton = isSingleButton
    self.closeAction = closeAction
    self.acceptAction = acceptAction
  }
  
  public var body: some View {
    ZStack {
      ColorSet.SubColor.backDrop
        .ignoresSafeArea()
      content
        .background(
          RoundedRectangle(cornerRadius: .Number10)
            .fill(ColorSet.Background.Primary)
        )
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: .Number320)
    }
  }
  
  @ViewBuilder
  private var content: some View {
    VStack(spacing: .Number20) {
      titleView
      buttonView
    }
    .padding(.horizontal, .Number16)
    .padding(.top, .Number20)
    .padding(.bottom, .Number16)
  }
  
  @ViewBuilder
  private var titleView: some View {
    VStack(spacing: .Number8) {
      Text(type.title)
        .font(FontSet.Title.title2)
        .foregroundStyle(ColorSet.Text.Primary)
        .multilineTextAlignment(.center)
      
      if let message = type.message {
        Text(message)
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Secondary)
          .multilineTextAlignment(.center)
      }
    }
  }
  
  @ViewBuilder
  private var buttonView: some View {
    HStack(spacing: .Number12) {
      if !isSingleButton {
        SecondaryButton(
          title: type.cancel,
          size: .large
        ) { closeAction() }
      }
      
      PrimaryButton(
        title: .constant(type.accept),
        size: .large,
        state: type.isErrorType ? .constant(.error) : .constant(.normal)
      ) { acceptAction() }
    }
  }
}
