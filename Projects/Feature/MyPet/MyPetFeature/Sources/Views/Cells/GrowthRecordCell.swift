//
//  GrowthRecordCell.swift
//  MyPetFeature
//
//  Created by 조용인 on 7/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import DesignKit

public struct GrowthRecordCell: View {
  public let record: GrowthRecord
  
  public init(
    record: GrowthRecord
  ) {
    self.record = record
  }
  
  public var body: some View {
    HStack(alignment: .center, spacing: .Number16) {
      HStack(alignment: .center, spacing: .Number12) {
        // 썸네일 이미지
        RoundedRectangle(cornerRadius: .Number8)
          .fill(record.isLocked ? ColorSet.Background.Tertiary : ColorSet.Gray._100)
          .frame(width: .Number64, height: .Number64)
          .overlay(
            Group {
              if record.isLocked {
                Icon(
                  image: .lock,
                  size: .Number24,
                  renderingMode: .template,
                  color: ColorSet.Icon.Tertiary
                )
              }
            }
          )
        
        // 정보 영역
        VStack(alignment: .leading, spacing: .Number4) {
          HStack(alignment: .center, spacing: .Number6) {
            Badge(text: .constant(record.level), state: .primary)
            
            Text(record.title)
              .font(FontSet.Body.body2)
              .foregroundColor(ColorSet.Text.Primary)
              .lineLimit(1)
          }
          
          if let date = record.date {
            Text(date)
              .font(FontSet.Caption.caption1)
              .foregroundColor(ColorSet.Text.Tertiary)
          }
          
        }
        
        Spacer()
      }
      
      // 쓰담 수
      Text(record.stampCount)
        .font(FontSet.Caption.caption1)
        .foregroundColor(ColorSet.Text.Tertiary)
    }
    .padding(.horizontal, .Number16)
    .padding(.vertical, .Number8)
    .opacity(record.isLocked ? 0.4 : 1.0)
  }
}
