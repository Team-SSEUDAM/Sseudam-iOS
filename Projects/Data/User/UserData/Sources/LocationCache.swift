//
//  LocationCache.swift
//  UserData
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//
import Foundation

actor LocationCache {
  
  private var list: [String] = []
  
  func load() {
    guard list.isEmpty else { return }
    loadJsonData()
  }
  
  func fetchList() -> [String] {
    return list
  }
  
  func deleteAll() {
    list.removeAll()
    if list.isEmpty {
      print("✅ 지역 리스트 삭제 완료")
    }
  }
  
  private func loadJsonData(from bundle: Bundle = Bundle(for: LocationCache.self)) {
    guard let url = bundle.url(forResource: "administrative_area_list", withExtension: "json") else {
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
