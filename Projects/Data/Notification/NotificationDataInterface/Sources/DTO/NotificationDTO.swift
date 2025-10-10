//
//  NotificationDto.swift
//
//  Notification
//
//  Created by Jiyeon
//

import Foundation
import NotificationDomainInterface
import NetworkKit

public struct NotificationDTO: DTO {
  public typealias Entity = NotificationEntity
  
  public let id: Int
  public let userId: Int
  public let type: String
  public let parameterValue: Int
  public let topic: String
  public let contents: String
  public let readStatus: String
  public let createdAt: String
  
}

extension NotificationDTO {
  public func toEntity() -> Entity {
    return .init(
      id: id,
      userId: userId,
      type: NotificationType(rawValue: type) ?? .regular,
      parameterValue: parameterValue,
      topic: topic,
      contents: contents,
      readStatus: readStatus == "READ" ? true : false,
      createdAt: createdAt
    )
  }
}
