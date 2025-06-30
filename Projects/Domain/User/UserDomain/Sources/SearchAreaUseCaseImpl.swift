//
//  SearchAreaUseCaseImpl.swift
//  UserDomain
//
//  Created by Jiyeon on 6/27/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation
import UserDomainInterface

extension SearchAreaUseCase {
  public static func live(repository: UserRepository) -> SearchAreaUseCase {
    .init { keyword in
      let allList = try await repository.fetchAreaList()
      guard !keyword.isEmpty else { return [] }
      return filterAreaList(list: allList, keyword: keyword)
      
    }
  }
}

// MARK: - Filter Helper

fileprivate func filterAreaList(list: [String], keyword: String) -> [String] {
  return list
    .map { address -> (score: Int, value: String) in
      let score = calculateSimilarityScore(text: address, query: keyword)
      if let bonus = partialInitialMatch(address: address, keyword: keyword) {
        return (max(score, bonus), address) // 더 높은 점수 사용
      }
      return (score, address)
    }
    .filter { $0.score > 0 }
    .sorted { $0.score > $1.score }
    .prefix(30)
    .map { $0.value }
}

/// "글자+초성" 패턴에 대한 점수 보너스
fileprivate func partialInitialMatch(address: String, keyword: String) -> Int? {
    // 예) keyword == "서대ㅁ"
    guard keyword.count > 1,
          let last = keyword.last,
          isKoreanConsonants(String(last)) else { return nil }
    let prefix = String(keyword.dropLast())
    // 주소에서 prefix가 있는지 찾고, 그 뒤의 초성 검사
    if let range = address.range(of: prefix) {
        let nextIndex = address.index(range.upperBound, offsetBy: 0)
        if nextIndex < address.endIndex {
            let nextChar = address[nextIndex]
            let nextChoseong = extractChoseong(String(nextChar))
            if nextChoseong == String(last) {
                return 70 // 적당한 점수 부여 (조정 가능)
            }
        }
    }
    return nil
}

// MARK: - 유사도 점수 계산 함수
fileprivate func calculateSimilarityScore(text: String, query: String) -> Int {
  guard !text.isEmpty, !query.isEmpty else { return 0 }
  
  let normalizedText = text.lowercased()
  let normalizedQuery = query.lowercased()
  
  if normalizedText == normalizedQuery { return 100 }
  if normalizedText.hasPrefix(normalizedQuery) { return 80 }
  if normalizedText.contains(normalizedQuery) { return 60 }
  
  let textWords = normalizedText.components(separatedBy: " ")
  let queryWords = normalizedQuery.components(separatedBy: " ")
  for queryWord in queryWords {
    for textWord in textWords {
      if textWord.hasPrefix(queryWord) { return 40 }
    }
  }
  
  // 초성 검색
  if isKoreanConsonants(normalizedQuery) {
    let textChoseong = extractChoseong(normalizedText)
    if textChoseong == normalizedQuery { return 30 }
    if textChoseong.hasPrefix(normalizedQuery) { return 25 }
    if textChoseong.contains(normalizedQuery) { return 20 }
    let textWordChoseongs = textWords.map { extractChoseong($0) }
    for queryChar in normalizedQuery {
      for wordChoseong in textWordChoseongs {
        if wordChoseong.hasPrefix(String(queryChar)) {
          return 15
        }
      }
    }
  }
  return 0
}

// 한글 문자열에서 초성을 추출
fileprivate func extractChoseong(_ text: String) -> String {
  var result = ""
  let hangulStart: UInt32 = 0xAC00
  let hangulEnd: UInt32 = 0xD7A3
  let choseong: [Character] = [
    "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ",
    "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
  ]
  
  for scalar in text.unicodeScalars {
    let charCode = scalar.value
    if charCode >= hangulStart && charCode <= hangulEnd {
      let index = Int((charCode - hangulStart) / 588)
      result.append(choseong[index])
    } else {
      result.append(Character(UnicodeScalar(charCode)!))
    }
  }
  return result
}

// 문자열이 한글 자음(초성)으로만 이루어져 있는지 확인
fileprivate func isKoreanConsonants(_ text: String) -> Bool {
  let consonants = Set("ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ")
  return !text.isEmpty && text.allSatisfy { consonants.contains($0) }
}
