//
//  AppVersionProject.swift
//
//  AppVersionData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.AppVersion,
  dependencies: [
    .Data.AppVersion.Interface,
  ]
)


