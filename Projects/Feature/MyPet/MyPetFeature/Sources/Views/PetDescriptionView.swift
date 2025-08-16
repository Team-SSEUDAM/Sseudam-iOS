//
//  PetDescriptionView.swift
//  MyPetFeature
//
//  Created by 조용인 on 8/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct PetDescriptionView: View {
  
  @State private var isPresented = false
  @State private var descriptionText = "쓰담을 모으면,\n펫을 성장시킬 수 있어요"
  @State private var descriptionDetailText = "쓰레기통 제보, 인증, 수정 제안을 통해 쓰담을 획득하세요."
  @State private var page: Int = 1
  
  let levels = [
    (level: "Lv.1", points: nil),
    (level: "Lv.2", points: "20 쓰담"),
    (level: "Lv.3", points: "110 쓰담"),
    (level: "Lv.4", points: "220 쓰담"),
    (level: "Special", points: "300 쓰담")
  ]
  
  let onDismiss: () -> Void
  
  public init(
    onDismiss: @escaping () -> Void
  ) {
    self.onDismiss = onDismiss
  }
  
  public var body: some View {
    ContentView
      .onAppear {
        withAnimation(.easeInOut(duration: 0.3)) { isPresented = true }
      }
  }
  
  public var ContentView: some View {
    ZStack {
      if isPresented {
        ColorSet.Gray._1000
          .opacity(0.4)
          .ignoresSafeArea()
          .transition(.opacity)
          .animation(.easeInOut(duration: 0.2), value: isPresented)
          .onTapGesture {
            dismissWithAnimation()
          }
      }
      
      VStack {
        Spacer()
        if isPresented {
          BottomSheetView
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: 0.3), value: isPresented)
            .onTapGesture { }
        }
      }
      .ignoresSafeArea()
    }
  }
  
  public var BottomSheetView: some View {
    VStack(spacing: .Number0) {
      BottomSheetContent
      BottomSheetButtons
    }
    .safeAreaPadding(.vertical)
    .background(ColorSet.Background.Primary)
    .clipCorners(.Number16, corners: [.topLeft, .topRight])
  }
  
  public var BottomSheetContent: some View {
    VStack(spacing: .Number16) {
      Description
      DescriptionDetail
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number20)
  }
  
  public var BottomSheetButtons: some View {
    HStack(spacing: .Number8) {
      switch page {
      case 1:
        SecondaryButton(title: "다음") {
          page = 2
          descriptionText = "마지막 단계에 도달하면,\n스페셜 펫을 만날 수 있어요"
          descriptionDetailText = "매달 새롭게 등장하는 스페셜 캐릭터를 키워보세요."
        }.frame(maxWidth: .infinity)
      case 2:
        SecondaryButton(title: "이전") {
          page = 1
          descriptionText = "쓰담을 모으면,\n펫을 성장시킬 수 있어요"
          descriptionDetailText = "쓰레기통 제보, 인증, 수정 제안을 통해 쓰담을 획득하세요."
        }.frame(maxWidth: .infinity)
        PrimaryButton(title: .constant("확인"), state: .constant(.normal)) { dismissWithAnimation() }.frame(maxWidth: .infinity)
      default:
        EmptyView()
      }
    }
    .padding(.Number16)
  }
  
  public var Description: some View {
    VStack(spacing: .Number12) {
      Text(descriptionText)
        .multilineTextAlignment(.center)
        .font(FontSet.Heading.heading3)
        .foregroundColor(ColorSet.Text.Primary)
        .contentTransition(.opacity)
        .animation(.smooth(duration: 0.3), value: descriptionText)
      
      Text(descriptionDetailText)
        .multilineTextAlignment(.center)
        .font(FontSet.Body.body3)
        .foregroundColor(ColorSet.Text.Secondary)
        .contentTransition(.opacity)
        .animation(.smooth(duration: 0.3), value: descriptionDetailText)
    }
  }
  
  public var DescriptionDetail: some View {
    ZStack {
      switch page {
      case 1: PetLevelGuide
      case 2: Image(asset: ImageSet.petDescriptionImage.swiftUIImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: .Number180, height: .Number180)
      default: EmptyView()
      }
    }
    .contentTransition(.opacity)
    .animation(.smooth(duration: 0.3), value: page)
    .frame(height: .Number180)
    .frame(maxWidth: .infinity)
  }
  
  public var PetLevelGuide: some View {
    GeometryReader { proxy in
      let fullWidth = proxy.size.width
      let itemWidth = fullWidth / CGFloat(levels.count)
      
      ZStack(alignment: .top) {
        PetLevelProgressView
          .padding(.top, 91.5)
          .padding(.horizontal, .Number12)
        ForEach(levels, id: \.level) { item in
          let index = levels.firstIndex(where: { $0.level == item.level }) ?? 0
          VerticalItem(item)
            .padding(.top, 91.5 + 40 + 12 + 18 + 10 + 1.5)
            .position(x: itemWidth * CGFloat(index) + 16 + 24)
        }
      }
    }
  }
  
  private func VerticalItem(_ item: (level: String, points: String?)) -> some View {
    VStack(spacing: .Number12) {
      if let point = item.points { VStack { CoachMark(text: point) }.frame(height: .Number40) }
      else { Spacer().frame(height: .Number40) }
      VStack(spacing: .Number10) {
        Node
        Badge(text: .constant(item.level), state: .primary)
      }
    }
  }
  
  private var Node: some View {
    Circle()
      .strokeBorder(ColorSet.Mint._300, lineWidth: 3)
      .background(Circle().fill(ColorSet.Background.Primary))
      .frame(width: .Number18, height: .Number18)
  }
  
  public var PetLevelBadges: some View {
    HStack(alignment: .center) {
      ForEach(levels, id: \.level) { item in
        Badge(text: .constant(item.level), state: .primary)
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  public var PetLevelProgressView: some View {
    Capsule()
      .foregroundStyle(
        LinearGradient(
          gradient: Gradient(
            colors: [
              Color(hex: "0xF2FAFF"),
              Color(hex: "0xA3D9FF")
            ]
          ),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .frame(height: .Number12)
      .padding(.horizontal, .Number24)
  }
  
  public func CoachMark(text: String) -> some View {
    VStack(spacing: .Number0) {
      Group {
        Text(text)
          .font(FontSet.Caption.caption1)
          .foregroundColor(ColorSet.Text.Inverse)
          .padding(.horizontal, .Number8)
          .padding(.vertical, .Number6)
      }
      .background(ColorSet.Background.Inverse)
      .elevation()
      .clipCorners(.Number10, corners: .allCorners)
      CoachMarkTail()
        .fill(ColorSet.Background.Inverse)
        .frame(width: .Number30, height: .Number8)
      
    }
    
  }
  
  public struct CoachMarkTail: Shape {
    public init() { }
    
    public func path(in rect: CGRect) -> Path {
      var path = Path()
      path.move(to: CGPoint(x: rect.minX, y: rect.minY))
      path.addCurve(
        to: CGPoint(x: rect.midX - 4, y: rect.maxY - 4.5),
        control1: CGPoint(x: rect.minX + 7.5, y: rect.minY),
        control2: CGPoint(x: rect.minX + 7.5, y: rect.minY - 1)
      )
      path.addQuadCurve(
        to: CGPoint(x: rect.midX + 4, y: rect.maxY - 4.5),
        control: CGPoint(x: rect.midX, y: rect.maxY + 3)
      )
      path.addCurve(
        to: CGPoint(x: rect.maxX, y: rect.minY),
        control1: CGPoint(x: rect.maxX - 7.5, y: rect.minY - 1),
        control2: CGPoint(x: rect.maxX - 7.5, y: rect.minY)
      )
      path.closeSubpath()
      
      return path
    }
  }
}

extension PetDescriptionView {
  private func dismissWithAnimation() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isPresented = false
    }
    
    // 애니메이션 완료 후 실제 dismiss 호출
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      onDismiss()
    }
  }
}
