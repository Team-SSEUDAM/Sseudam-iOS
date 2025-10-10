//
//  NotificationEntity.swift
//
//  NotificationDomainInterface
//
//  Created by Jiyeon
//

import Foundation

public struct NotificationEntity: Sendable, Equatable, Identifiable {
  public var id: Int
  public var userId: Int
  public var type: NotificationType
  public var parameterValue: Int
  public var topic: String
  public var contents: String
  public var readStatus: Bool
  public var createdAt: Date
  
  public init(
    id: Int,
    userId: Int,
    type: NotificationType,
    parameterValue: Int,
    topic: String,
    contents: String,
    readStatus: Bool,
    createdAt: Date
  ) {
    self.id = id
    self.userId = userId
    self.type = type
    self.parameterValue = parameterValue
    self.topic = topic
    self.contents = contents
    self.readStatus = readStatus
    self.createdAt = createdAt
  }
}

