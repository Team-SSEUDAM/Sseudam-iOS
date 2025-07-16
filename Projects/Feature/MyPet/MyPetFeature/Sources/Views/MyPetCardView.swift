//
//  MyPetCardView.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct MyPetCardView: View {
  
  private let level: String
  private let petNickName: String
  
  private let nextLevelText: String
  
  private let currentStamps: Int
  private let goalStamp: Int
  
  
  @State private var progress: CGFloat = 0.0
  
  public init(
    level: Int,
    petNickName: String,
    currentStamps: Int,
    goalStamp: Int
  ) {
    self.level = "Lv.\(level)"
    self.petNickName = petNickName
    self.nextLevelText = "다음 레벨까지 \(goalStamp - currentStamps)쓰담"
    self.currentStamps = currentStamps
    self.goalStamp = goalStamp
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: .Number4) {
      /// --------- 헤더 영역 ---------
      HStack(spacing: .Number6) {
        Badge(text: .constant(level), state: .primary)
        Text(petNickName)
          .font(FontSet.Heading.heading3)
          .foregroundStyle(ColorSet.Text.Primary)
        Icon(
          image: .edit,
          size: .Number20,
          renderingMode: .template,
          color: ColorSet.Icon.Tertiary
        )
      }
      .onTapGesture {
        // TODO: 네비게이션 액션
      }
      
      /// --------- 목표 영역 ---------
      Text(nextLevelText)
        .font(FontSet.Caption.caption1)
        .foregroundStyle(ColorSet.Text.Secondary)
      
      
      /// --------- 프로그래스 영역 ---------
      HStack(alignment: .center, spacing: .Number8) {
        ZStack(alignment: .leading) {
          /// 배경
          RoundedRectangle(cornerRadius: .Number100)
            .fill(ColorSet.Background.Tertiary)
            .frame(height: .Number6)
          
          /// 진행도
          GeometryReader { geometry in
            RoundedRectangle(cornerRadius: .Number100)
              .fill(ColorSet.Component.Primary)
              .frame(
                width: progress * geometry.size.width,
                height: .Number6
              )
              .animation(.easeInOut(duration: 0.5), value: progress)
          }
          .frame(height: .Number6)
        }
        .frame(height: .Number6)
        
        Text("\(currentStamps) / \(goalStamp) 쓰담")
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Primary)
      }
    }
    .padding(.Number20)
    .background(ColorSet.Background.Primary)
    .cornerRadius(.Number16)
    .elevation(level: .medium, cornerRadius: .Number16)
    .onAppear {
      withAnimation(.easeInOut(duration: 1.0)) {
        progress = goalStamp > 0 ? CGFloat(currentStamps) / CGFloat(goalStamp) : 0.0
      }
    }
  }
}
