//
//  SettingView.swift
//  MyPageFeature
//
//  Created by Jiyeon on 7/11/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture

public struct SettingView: View {
  @Bindable var store: StoreOf<SettingFeature>

  public init(store: StoreOf<SettingFeature>) {
    self.store = store
  }

  public var body: some View {
    ZStack {
      ColorSet.Background.Primary
        .ignoresSafeArea()
      VStack(spacing: .Number0) {
        NavigationBarView
        settingListView
        Spacer()
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  @ViewBuilder
  private var NavigationBarView: some View {
    NavigationBar(
      backContent: {
        TouchArea(image: .leftChevron, {
          store.send(.pop)
        })
      },
      title: "설정"
    )
    
  }
  
  @ViewBuilder
  private var settingListView: some View {
    SettingItemListView(title: "서비스", items: serviceItems()) { _ in
//      store.send(.settingListTapped($0))
    }
    
    BorderView(size: .xlarge)
    SettingItemListView(title: "알림 설정", items: notification()) { _ in
//      store.send(.settingListTapped($0))
    }
    
    BorderView(size: .xlarge)
    SettingItemListView(title: "기타", items: etcItems()) { _ in
//      store.send(.settingListTapped($0))
    }
    
    if store.isLoggedIn {
      BorderView(size: .xlarge)
      SettingItemListView(items: accountItems()) { _ in
//        store.send(.settingListTapped($0))
      }
    }
  }
}

// MARK: - Data

extension SettingView {
  
  private func serviceItems() -> [SettingItem] {
    [
      .init(type: .suggestion, title: "쓰레기통 제보하기", icon: .addSpot),
      .init(type: .feedback, title: "피드백 남기기", icon: .feedback)
    ]
  }
  
  private func notification() -> [SettingItem] {
    [
      .init(type: .notification, title: "푸시 알림", icon: .notification)
    ]
  }
  
  private func etcItems() -> [SettingItem] {
    [
      .init(type: .update, title: "최신버전 업데이트", subtitle: "v2.0/v1.0", trailing: true ? "업데이트" : "최신버전 사용 중"),
      .init(type: .serviceTerm, title: "서비스 이용약관"),
      .init(type: .privacyTerm, title: "개인정보 처리방침")
    ]
  }
  
  private func accountItems() -> [SettingItem] {
    [
      .init(type: .logout, title: "로그아웃"),
      .init(type: .withdraw, title: "탈퇴하기")
    ]
  }
}
