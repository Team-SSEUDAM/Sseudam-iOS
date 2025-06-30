//
//  AreaListCache.swift
//  Utility
//
//  Created by Jiyeon on 6/30/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

public actor AreaListCache {
  
  private var list: [String] = []
  
  public init(){}
  
  public func load() {
    guard list.isEmpty else { return }
    loadJsonData()
  }
  
  public func fetchList() -> [String] {
    return list
  }
  
  public func deleteAll() {
    list.removeAll()
    if list.isEmpty {
      print("✅ 지역 리스트 삭제 완료")
    }
  }
  
  private func loadJsonData() {
    guard let url = Bundle.module.url(forResource: "administrative_area_list", withExtension: "json") else {
      print("❌ 지역 리스트 URL 못찾음")
      return
    }
    
    do {
      let loaded = try JSONDecoder().decode([String].self, from: try Data(contentsOf: url))
      self.list = loaded.map { String($0) }
      print("✅ 지역 리스트 성공적으로 불러옴, 총 \(loaded.count)개")
    } catch {
      print("❌ 지역 리스트 로드 실패: \(error)")
    }
  }
  
  
}
