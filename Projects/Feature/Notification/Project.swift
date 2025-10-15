//
//  NotificationProject.swift
//
//  Notification
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Notification,
  dependencies: [
    .Domain.Umbrella
  ]
)

