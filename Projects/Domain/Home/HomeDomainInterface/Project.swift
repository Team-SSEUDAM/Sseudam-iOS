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
    .Shared.ThirdParty,
    .Shared.Utility
    
  ],
  nameSuffix: "Interface"
)
