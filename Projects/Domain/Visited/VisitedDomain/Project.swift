//
//  VisitedProject.swift
//
//  VisitedDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.Visited,
  dependencies: [
    .Domain.Visited.Interface
  ]
)

