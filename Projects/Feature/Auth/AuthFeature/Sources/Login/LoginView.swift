//
//  LoginView.swift
//  AuthFeature
//
//  Created by Jiyeon on 6/22/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct LoginView: View {
  @Bindable var store: StoreOf<LoginFeature>
  
  public init(store: StoreOf<LoginFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack {
        NavigationBar(
          closeContent: {
            TouchArea(image: .close) {
              store.send(.closeButtonTapped)
            }
          }
        )
        VStack(alignment: .center, spacing: .Number16) {
          Spacer()
          // TODO: - 앱 로고 이미지로 바꾸기
          RoundedRectangle(cornerRadius: .Number8)
            .frame(width: .Number100, height: .Number100)
            .foregroundStyle(ColorSet.Background.Secondary)
          TitleView
          Spacer()
          VStack(spacing: .Number16) {
            AppleLogin
          }
          .padding(.Number16)
        }
        
      }
    }
  }
  
  @ViewBuilder
  private var TitleView: some View {
    VStack(alignment: .center, spacing: .Number8) {
      Text("쓰담")
        .font(FontSet.Heading.heading1)
        .foregroundStyle(ColorSet.Text.Primary)
      Text("이메일이나 비밀번호 없이 3초 안에 로그인하세요")
        .font(FontSet.Body.body3)
        .foregroundStyle(ColorSet.Text.Secondary)
    }
  }
  
  @ViewBuilder
  private var AppleLogin: some View {
    PrimaryButton(
      icon: {
        Icon(image: .apple, size: .Number20, color: .white)
      },
      title: .constant("Apple로 계속하기"),
      size: .large,
      state: .constant(
          .custom(
        bg: ColorSet.SocialLogin.Apple,
        text: .white
      ))
    ) {
        store.send(.appleLoginTapped)
    }
  }
  
  @ViewBuilder
  private var KakaoLogin: some View {
    PrimaryButton(
      icon: {
        Icon(image: .kakao, size: .Number20, color: ColorSet.Gray._1000)
      },
      title: .constant("카카오로 계속하기"),
      size: .large,
      state: .constant(
        .custom(
          bg: ColorSet.SocialLogin.Kakao,
          text: ColorSet.Text.Primary
        ))
    ) { }
  }
}
