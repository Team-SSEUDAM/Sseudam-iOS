//
//  Color+.swift
//  DesignKit
//
//  Created by 조용인 on 3/14/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation
import SwiftUI

extension DesignKitAsset {
  
  public struct ColorSet: Sendable {
    
    public struct Gray: Sendable {
      public static let _0 = DesignKitAsset.Colors.gray0.swiftUIColor
      public static let _50 = DesignKitAsset.Colors.gray50.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.gray100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.gray200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.gray300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.gray400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.gray500.swiftUIColor
      public static let _600 = DesignKitAsset.Colors.gray600.swiftUIColor
      public static let _700 = DesignKitAsset.Colors.gray700.swiftUIColor
      public static let _800 = DesignKitAsset.Colors.gray800.swiftUIColor
      public static let _900 = DesignKitAsset.Colors.gray900.swiftUIColor
      public static let _1000 = DesignKitAsset.Colors.gray1000.swiftUIColor
    }
    
    public struct Mint: Sendable {
      public static let _50 = DesignKitAsset.Colors.mint50.swiftUIColor
      public static let _75 = DesignKitAsset.Colors.mint75.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.mint100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.mint200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.mint300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.mint400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.mint500.swiftUIColor
    }
    
    public struct Pink: Sendable {
      public static let _50 = DesignKitAsset.Colors.pink50.swiftUIColor
      public static let _75 = DesignKitAsset.Colors.pink75.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.pink100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.pink200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.pink300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.pink400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.pink500.swiftUIColor
    }
    
    public struct SubColor: Sendable {
      public static let red = DesignKitAsset.Colors.red.swiftUIColor
      public static let backDrop = DesignKitAsset.Colors.backDrop.swiftUIColor
    }
    
    public struct Orange: Sendable {
      public static let _0 = DesignKitAsset.Colors.orange0.swiftUIColor
      public static let _50 = DesignKitAsset.Colors.orange50.swiftUIColor
      public static let _100 = DesignKitAsset.Colors.orange100.swiftUIColor
      public static let _200 = DesignKitAsset.Colors.orange200.swiftUIColor
      public static let _300 = DesignKitAsset.Colors.orange300.swiftUIColor
      public static let _400 = DesignKitAsset.Colors.orange400.swiftUIColor
      public static let _500 = DesignKitAsset.Colors.orange500.swiftUIColor
    }
    
    public struct Border: Sendable {
      public static let Strong = ColorSet.Gray._500
      public static let Primary = ColorSet.Gray._200
      public static let Secondary = ColorSet.Gray._100
      public static let Error = ColorSet.SubColor.red
      public static let Accent = ColorSet.Mint._300
      public static let Inverse = ColorSet.Gray._0
    }
    
    public struct Icon: Sendable {
      public static let Primary = ColorSet.Gray._700
      public static let Secondary = ColorSet.Gray._400
      public static let Tertiary = ColorSet.Gray._300
      public static let Accent = ColorSet.Mint._400
      public static let Inverse = ColorSet.Gray._0
    }
    
    public struct Text: Sendable {
      public static let Primary = ColorSet.Gray._700
      public static let Secondary = ColorSet.Gray._400
      public static let Tertiary = ColorSet.Gray._300
      public static let Disabled = ColorSet.Gray._300
      public static let Accent = ColorSet.Mint._400
      public static let Error = ColorSet.SubColor.red
      public static let Inverse = ColorSet.Gray._0
      public static let InverseAccent = ColorSet.Mint._100
    }
    
    public struct Background: Sendable {
      public static let Primary = ColorSet.Gray._0
      public static let Secondary = ColorSet.Gray._50
      public static let Tertiary = ColorSet.Gray._100
      public static let Inverse = ColorSet.Gray._700
      public static let Accent = ColorSet.Mint._50
    }
    
    public struct Component: Sendable {
      public static let Primary = ColorSet.Mint._300
      public static let Disabled = ColorSet.Gray._50
      public static let Pressed = ColorSet.Gray._1000.opacity(0.12)
      public static let Error = ColorSet.SubColor.red
    }
    
    public struct SocialLogin: Sendable {
      public static let Kakao = DesignKitAsset.Colors.kakao.swiftUIColor
      public static let Apple = ColorSet.Gray._1000
    }
    
    public struct HexColor: Sendable {
      public static let _006F9D = DesignKitAsset.Colors._006F9D.swiftUIColor
      public static let _9Fd5Fb = DesignKitAsset.Colors._9Fd5Fb.swiftUIColor
      public static let _E0F2Ff = DesignKitAsset.Colors.e0F2Ff.swiftUIColor
    }
  }
}

/// 헥사코드로 색상을 정의할 수 있는 확장
/// 사용 예시:
///
///```swift
/// let color = Color(hex: "#FF5733")
/// let color = Color(hex: "FF5733")
/// let color = Color(hex: "#FF5733FF") // 8자리 RGBA 형식
/// ```
extension Color {
  public init(hex: String) {
    let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    let scanner = Scanner(string: hex)
    
    if hex.hasPrefix("#") {
      scanner.currentIndex = hex.index(after: hex.startIndex)
    }
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let red = Double((rgb >> 16) & 0xFF) / 255.0
    let green = Double((rgb >> 8) & 0xFF) / 255.0
    let blue = Double(rgb & 0xFF) / 255.0
    
    self.init(red: red, green: green, blue: blue)
  }
}
