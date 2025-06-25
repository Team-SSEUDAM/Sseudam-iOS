//
//  UserProject.swift
//
//  UserDomainInterface
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.User,
  dependencies: [
    .Shared.ThirdParty,
    .Shared.Utility
  ],
  nameSuffix: "Interface"
)
