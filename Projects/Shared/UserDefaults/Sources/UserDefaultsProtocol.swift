//
//  UserDefaultsProtocol.swift
//  UserDefaults
//
//  Created by Jiyeon on 6/16/25.
//  Copyright © 2025 Sseudam.a2bo.ios. All rights reserved.
//

import Foundation

protocol UserDefaultProtocol: RawRepresentable where RawValue == String { }

extension UserDefaultProtocol {
  public var rawValue: String { String(describing: self) }
  
  public init?(rawValue: String) {
    self.init(rawValue: rawValue)
  }
  
  public func save<T: Sendable & Decodable>(_ value: T?) {
    UserDefaults.standard.set(value, forKey: self.rawValue)
  }
  
  public func load<T: Sendable & Decodable>() -> T? {
    return UserDefaults.standard.object(forKey: self.rawValue) as? T
  }
  
  public func delete() {
    UserDefaults.standard.removeObject(forKey: self.rawValue)
  }
}
