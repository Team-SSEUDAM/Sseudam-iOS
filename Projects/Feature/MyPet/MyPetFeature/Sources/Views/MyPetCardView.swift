//
//  MyPetCardView.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit
import PetDomainInterface

public struct MyPetCardView: View {
  
  private let level: Int
  private let petNickName: String
  private let nextLevelText: String
  private let currentStamps: Int
  private let goalStamp: Int
  private let myPetInfo :PetInfoEntity?
  
  public var action: @Sendable () -> Void
  
  private var progress: CGFloat { goalStamp > 0 ? CGFloat(currentStamps) / CGFloat(goalStamp) : 0.0 }
  
  public init(
    myPetInfo: PetInfoEntity?,
    _ action: @escaping @Sendable () -> Void
  ) {
    self.level = myPetInfo?.levelType.rawInt ?? 1
    self.petNickName = myPetInfo?.nickname ?? "서버 오류 냥이"
    self.currentStamps = myPetInfo?.currentPoint ?? 0
    self.goalStamp = myPetInfo?.goalPoint ?? 0
    self.nextLevelText = level == 5 ? "최대 레벨을 달성했습니다 🎉" : "다음 레벨까지 \(goalStamp - currentStamps)쓰담"
    self.action = action
    self.myPetInfo = myPetInfo
  }
  
  public var body: some View {
    ContentView
    
    //TODO: - 서버 오류로 인해 펫 정보가 없는 경우 뭘 보여줘야할까
    if myPetInfo != nil {  }
    else {  }
  }
  
  @ViewBuilder
  private var ContentView: some View {
    VStack(alignment: .leading, spacing: .Number4) {
      /// --------- 헤더 영역 ---------
      HStack(spacing: .Number6) {
        Badge(text: .constant("Lv.\(level)"), state: .primary)
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
        action()
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
        
        Text( level == 5 ? "Max" : "\(currentStamps) / \(goalStamp) 쓰담")
          .font(FontSet.Body.body3)
          .foregroundStyle(ColorSet.Text.Primary)
      }
    }
    .padding(.Number20)
    .background(ColorSet.Background.Primary)
    .cornerRadius(.Number10)
    .elevation(level: .small, cornerRadius: .Number10)
  }
}
