//
//  DetailMessageAlert.swift
//  DesignKit
//
//  Created by Jiyeon on 10/10/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI

public struct DetailMessageAlert: View {
  
  private let type: AlertType
  private let acceptAction: @Sendable () -> Void
  
  public init(
    type: AlertType,
    acceptAction: @escaping @Sendable () -> Void = {}
  ) {
    self.type = type
    self.acceptAction = acceptAction
  }
  
  public var body: some View {
    ZStack {
      ColorSet.SubColor.backDrop
        .ignoresSafeArea()
      VStack(spacing: .Number20) {
        content
        SecondaryButton(
          title: .constant(type.accept),
          state: .constant(.normal)
        ) {
          acceptAction()
        }
      }
      .padding(.top, .Number20)
      .padding(.bottom, .Number16)
      .padding(.horizontal, .Number16)
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
    VStack(spacing: .Number16) {
      Text(type.title)
        .font(FontSet.Title.title2)
        .foregroundStyle(ColorSet.Text.Primary)
        .multilineTextAlignment(.center)
      detailMessage
    }
    .padding(.horizontal, .Number16)
  }
  
  @ViewBuilder
  private var detailMessage: some View {
    if let subTitle = type.subTitle,
       let message = type.message {
      HStack {
        Spacer()
        VStack(spacing: .Number4) {
          Text(subTitle)
            .font(FontSet.Title.title3)
            .foregroundStyle(ColorSet.Text.Primary)
          Text(message)
            .font(FontSet.Body.body3)
            .foregroundStyle(ColorSet.Text.Secondary)
        }
        Spacer()
      }
      .padding(.vertical, .Number12)
      .padding(.horizontal, .Number16)
      .background(ColorSet.Background.Secondary)
      .cornerRadius(.Number4)
    }
  }
}
