//
//  VisitedProject.swift
//
//  VisitedData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Data.Visited,
  dependencies: [
    .Data.Visited.Interface,
  ]
)


