//
//  HomeRepositoryImpl.swift
//
//  Home
//
//  Created by JiYeon
//

import Foundation
import HomeDomainInterface
import HomeDataInterface

public extension HomeRepository {
  static var live: HomeRepository {
    HomeRepository(
      fetchData: {
        return "Hello, World!"
      }
    )
  }
}
