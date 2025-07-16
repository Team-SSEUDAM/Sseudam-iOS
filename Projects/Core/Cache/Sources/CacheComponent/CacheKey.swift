//
//  CacheKey.swift
//  Cache
//
//  Created by 조용인 on 3/21/25.
//  Copyright © 2025 com.yongin.pida. All rights reserved.
//

import Foundation


/// 캐시 키를 정의하는 구조체
public protocol CacheKey: Hashable {
  var directory: String { get }
  var identifier: String { get }
  var fileName: String { get }
}

public enum SampleCacheKey: CacheKey {
  case 여기에는_캐시파일_이름
  
  public var directory: String { "SampleDirectory" }
  public var fileName: String { "\(identifier).cache" }
  
  public var identifier: String {
    switch self {
    case .여기에는_캐시파일_이름: "여기에는_캐시파일_이름"
    }
  }
}

public enum MyPetCacheKey: CacheKey {
  case myPetInfo
  
  public var directory: String { "MyPet" }
  public var fileName: String { "\(identifier).cache" }
  
  public var identifier: String {
    switch self {
    case .myPetInfo: "my_pet_info"
    }
  }
}
