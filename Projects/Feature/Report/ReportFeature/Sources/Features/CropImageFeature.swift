//
//  CropImageFeature.swift
//  ReportFeature
//
//  Created by 조용인 on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

@Reducer
public struct CropImageFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public var originalImage: UIImage
    public var croppedImage: UIImage?
    
    public var imageScale: CGFloat = 1.0
    public var imageOffset: CGSize = .zero
    
    public var gridSize: CGFloat = 300.0
    public var gridPosition: CGPoint = .zero
    
    public init(originalImage: UIImage) {
      self.originalImage = originalImage
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case viewDidAppear
    case setGridSize(CGFloat)
    case setGridPosition(CGPoint)
    
    case gridSizeChanged(CGFloat)
    case gridOffsetChanged(CGSize)
    
    case confirmCrop
    case cancel
    case performCrop
    case cropCompleted(UIImage)
    
    public enum Delegate: Equatable {
      case imageCropped(UIImage)
      case cancelled
    }
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .viewDidAppear:
        return .none
      case let .setGridSize(size):
        state.gridSize = size
        return .none
      case let .setGridPosition(position):
        state.gridPosition = position
        return .none
      case .confirmCrop:
        return .send(.performCrop)
      case .performCrop:
        let state = state
        return .run { send in
          // 크롭 작업 수행
          let cropImage = await CropImageFeature.cropImage(
            state.originalImage,
            cropSize: state.gridSize,
            imageScale: state.imageScale,
            imageOffset: state.imageOffset
          )
          await send(.cropCompleted(cropImage))
        }
      case let .cropCompleted(croppedImage):
        state.croppedImage = croppedImage
        return .send(.delegate(.imageCropped(croppedImage)))
      case .cancel:
        return .send(.delegate(.cancelled))
      default:
        return .none
      }
    }
  }
}

// MARK: - Image Cropping Logic
extension CropImageFeature {
  /// 이미지를 크롭하는 함수
  /// - Parameters:
  ///   - image: 원본 이미지
  ///   - cropSize: 크롭 영역의 크기 (정사각형)
  ///   - imageScale: 이미지의 현재 스케일
  ///   - imageOffset: 이미지의 현재 오프셋
  /// - Returns: 크롭된 이미지
  @MainActor
  private static func cropImage(
    _ image: UIImage,
    cropSize: CGFloat,
    imageScale: CGFloat,
    imageOffset: CGSize
  ) -> UIImage {
    guard let cgImage = image.cgImage else { return image }
    
    // 이미지의 실제 크기
    let imageWidth = CGFloat(cgImage.width)
    let imageHeight = CGFloat(cgImage.height)
    
    // 화면에 표시되는 이미지의 크기 계산 (스케일 적용 전)
    let aspectRatio = imageWidth / imageHeight
    let displayedImageSize: CGSize
    
    if aspectRatio > 1 {
      // 가로가 더 긴 이미지
      displayedImageSize = CGSize(
        width: cropSize,
        height: cropSize / aspectRatio
      )
    } else {
      // 세로가 더 긴 이미지
      displayedImageSize = CGSize(
        width: cropSize * aspectRatio,
        height: cropSize
      )
    }
    
    // 스케일이 적용된 표시 크기
    let scaledDisplaySize = CGSize(
      width: displayedImageSize.width * imageScale,
      height: displayedImageSize.height * imageScale
    )
    
    // 화면 좌표에서 실제 이미지 좌표로 변환하는 스케일
    let displayToImageScale = CGSize(
      width: imageWidth / scaledDisplaySize.width,
      height: imageHeight / scaledDisplaySize.height
    )
    
    // 크롭 영역의 좌상단 점 계산 (화면 좌표계)
    // 크롭 프레임은 화면 중앙에 고정되어 있고, 이미지가 offset만큼 이동했음
    let cropOriginInDisplay = CGPoint(
      x: (scaledDisplaySize.width - cropSize) / 2 - imageOffset.width,
      y: (scaledDisplaySize.height - cropSize) / 2 - imageOffset.height
    )
    
    // 실제 이미지 좌표계로 변환
    let cropRect = CGRect(
      x: cropOriginInDisplay.x * displayToImageScale.width,
      y: cropOriginInDisplay.y * displayToImageScale.height,
      width: cropSize * displayToImageScale.width,
      height: cropSize * displayToImageScale.height
    )
    
    // 크롭 영역이 이미지 범위를 벗어나지 않도록 조정
    let clampedRect = CGRect(
      x: max(0, min(imageWidth - cropRect.width, cropRect.origin.x)),
      y: max(0, min(imageHeight - cropRect.height, cropRect.origin.y)),
      width: min(imageWidth - max(0, cropRect.origin.x), cropRect.width),
      height: min(imageHeight - max(0, cropRect.origin.y), cropRect.height)
    )
    
    // 크롭 수행
    guard let croppedCGImage = cgImage.cropping(to: clampedRect) else { return image }
    
    // UIImage 생성
    let croppedImage = UIImage(
      cgImage: croppedCGImage,
      scale: 1.0,
      orientation: image.imageOrientation
    )
    
    // 정사각형으로 리사이즈 (고해상도 유지)
    return resizeToSquare(croppedImage, targetSize: 1080)
  }

  /// 이미지를 정사각형으로 리사이즈 (개선된 버전)
  private static func resizeToSquare(_ image: UIImage, targetSize: CGFloat) -> UIImage {
    let size = CGSize(width: targetSize, height: targetSize)
    
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1.0
    format.opaque = false
    
    let renderer = UIGraphicsImageRenderer(size: size, format: format)
    
    return renderer.image { context in
      // 배경을 검은색으로 채우기 (선택사항)
      context.cgContext.setFillColor(UIColor.black.cgColor)
      context.cgContext.fill(CGRect(origin: .zero, size: size))
      
      // 이미지 비율 유지하면서 중앙에 그리기
      let imageSize = image.size
      let scale = min(targetSize / imageSize.width, targetSize / imageSize.height)
      let scaledSize = CGSize(
        width: imageSize.width * scale,
        height: imageSize.height * scale
      )
      let drawRect = CGRect(
        x: (targetSize - scaledSize.width) / 2,
        y: (targetSize - scaledSize.height) / 2,
        width: scaledSize.width,
        height: scaledSize.height
      )
      
      image.draw(in: drawRect)
    }
  }
}
