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
    .Shared.ThirdParty,
    .Shared.Utility,
    .Core.DesignKit
  ],
  nameSuffix: "Interface"
)
