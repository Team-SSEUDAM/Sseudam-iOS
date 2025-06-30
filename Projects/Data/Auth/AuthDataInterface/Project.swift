//
//  AuthProject.swift
//
//  AuthData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Auth,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


