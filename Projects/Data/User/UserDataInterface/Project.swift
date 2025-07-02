//
//  UserProject.swift
//
//  UserData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.User,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


