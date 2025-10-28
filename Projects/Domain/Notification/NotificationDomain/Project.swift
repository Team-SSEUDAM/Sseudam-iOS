//
//  NotificationProject.swift
//
//  NotificationDomain
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Notification,
  dependencies: [
    .Domain.Notification.Interface
  ]
)

