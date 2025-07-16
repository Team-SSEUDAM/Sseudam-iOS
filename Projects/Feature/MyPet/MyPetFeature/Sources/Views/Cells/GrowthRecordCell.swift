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
    HStack(spacing: 16) {
      // 썸네일 이미지
      RoundedRectangle(cornerRadius: 8)
        .fill(record.isLocked ? ColorSet.Background.Tertiary : ColorSet.Background.Secondary)
        .frame(width: 60, height: 60)
        .overlay(
          Group {
            if record.isLocked {
              Icon(
                image: .lock,
                size: .Number24,
                renderingMode: .template,
                color: ColorSet.Icon.Tertiary
              )
            } else {
              RoundedRectangle(cornerRadius: 8)
                .fill(ColorSet.Component.Primary.opacity(0.2))
            }
          }
        )
      
      // 정보 영역
      VStack(alignment: .leading, spacing: 4) {
        HStack(spacing: 6) {
          Text(record.level)
            .font(FontSet.Caption.caption1)
            .foregroundColor(ColorSet.Text.Tertiary)
          
          Text(record.title)
            .font(FontSet.Body.body2)
            .foregroundColor(ColorSet.Text.Primary)
            .lineLimit(1)
        }
        
        Text(record.date)
          .font(FontSet.Caption.caption1)
          .foregroundColor(ColorSet.Text.Tertiary)
      }
      
      Spacer()
      
      // 쓰담 수
      Text(record.stampCount)
        .font(FontSet.Body.body3)
        .foregroundColor(ColorSet.Text.Secondary)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .opacity(record.isLocked ? 0.5 : 1.0)
  }
}
