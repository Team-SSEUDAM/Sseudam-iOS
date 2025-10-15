//
//  NotificationProject.swift
//
//  NotificationData
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Notification,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


