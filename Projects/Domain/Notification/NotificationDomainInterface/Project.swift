//
//  NotificationProject.swift
//
//  NotificationDomainInterface
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Notification,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
