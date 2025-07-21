//
//  VisitedProject.swift
//
//  VisitedDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Visited,
  dependencies: [
    .Domain.Visited.Interface
  ]
)

