//
//  AppVersionProject.swift
//
//  AppVersionDomainInterface
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.AppVersion,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
