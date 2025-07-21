//
//  VisitedProject.swift
//
//  VisitedDomainInterface
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Visited,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
