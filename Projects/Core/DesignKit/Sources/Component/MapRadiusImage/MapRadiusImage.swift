//
//  MapRadiusImage.swift
//  DesignKit
//
//  Created by Jiyeon on 10/15/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import UIKit
import NMapsMap

public enum MapRadiusImage {
  
  public static let image: UIImage = {
    let size = CGSize(width: 512, height: 512)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    let ctx = UIGraphicsGetCurrentContext()!
    let centerColor = UIColor(ColorSet.Background.Primary.opacity(0))
    let edgeColor = UIColor(ColorSet.Background.Primary.opacity(0.6))
    
    let colors = [centerColor.cgColor, edgeColor.cgColor] as CFArray
    let locations: [CGFloat] = [0.0, 1.0]
    let space = CGColorSpaceCreateDeviceRGB()
    let gradient = CGGradient(colorsSpace: space, colors: colors, locations: locations)!

    let c = CGPoint(x: size.width/2, y: size.height/2)
    let r = min(size.width, size.height) / 2
    ctx.addEllipse(in: CGRect(origin: .zero, size: size))
    ctx.clip()
    ctx.drawRadialGradient(
      gradient,
      startCenter: c, startRadius: 0,
      endCenter: c, endRadius: r,
      options: .drawsAfterEndLocation
    )

    let img = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return img
  }()
  
  public static let overlayImage = NMFOverlayImage(image: MapRadiusImage.image)
}
