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
    
    public var imageAreaSize: CGSize = .zero
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
    case setImageAreaSize(CGSize)
    
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
        
      case let .setImageAreaSize(size):
        state.imageAreaSize = size
        return .none
        
      case .confirmCrop:
        return .send(.performCrop)
        
      case .performCrop:
        let state = state
        return .run { send in
          let cropImage = await CropImageFeature.cropImage(
            state.originalImage,
            gridSize: state.gridSize,
            gridPosition: state.gridPosition,
            containerSize: state.imageAreaSize
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
  @MainActor
  private static func cropImage(
    _ image: UIImage,
    gridSize: CGFloat,
    gridPosition: CGPoint,
    containerSize: CGSize
  ) -> UIImage {
    // 이미지의 실제 표시 크기 (orientation 적용된)
    let imageSize = image.size
    let imageAspectRatio = imageSize.width / imageSize.height
    
    // 컨테이너에 맞춰진 이미지의 표시 크기 계산
    let containerAspectRatio = containerSize.width / containerSize.height
    let displayedImageSize: CGSize
    let displayedImageOrigin: CGPoint
    
    if imageAspectRatio > containerAspectRatio {
      let width = containerSize.width
      let height = width / imageAspectRatio
      displayedImageSize = CGSize(width: width, height: height)
      displayedImageOrigin = CGPoint(x: 0, y: (containerSize.height - height) / 2)
    } else {
      let height = containerSize.height
      let width = height * imageAspectRatio
      displayedImageSize = CGSize(width: width, height: height)
      displayedImageOrigin = CGPoint(x: (containerSize.width - width) / 2, y: 0)
    }
    
    // 스케일 계산
    let scale = imageSize.width / displayedImageSize.width
    
    // 그리드 영역 계산
    let gridOrigin = CGPoint(
      x: (gridPosition.x - gridSize / 2 - displayedImageOrigin.x) * scale,
      y: (gridPosition.y - gridSize / 2 - displayedImageOrigin.y) * scale
    )
    
    let cropRect = CGRect(
      x: gridOrigin.x,
      y: gridOrigin.y,
      width: gridSize * scale,
      height: gridSize * scale
    )
    
    // UIGraphicsImageRenderer를 사용한 크롭
    let format = UIGraphicsImageRendererFormat()
    format.scale = image.scale
    format.opaque = false
    
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: gridSize * scale, height: gridSize * scale), format: format)
    
    let croppedImage = renderer.image { context in
      // 크롭 영역만큼 이동시켜서 그리기
      image.draw(at: CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y))
    }
    
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
