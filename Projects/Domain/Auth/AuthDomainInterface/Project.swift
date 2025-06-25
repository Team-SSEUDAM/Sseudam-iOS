//
//  AuthProject.swift
//
//  AuthDomainInterface
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Auth,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
