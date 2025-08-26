//
//  AppVersionProject.swift
//
//  AppVersionDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.AppVersion,
  dependencies: [
    .Domain.AppVersion.Interface
  ]
)

