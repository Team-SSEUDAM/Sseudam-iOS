//
//  HomeProject.swift
//
//  HomeDomainInterface
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Home,
  dependencies: [
    .Core.Module,
    .Shared.Module
  ],
  nameSuffix: "Interface"
)
