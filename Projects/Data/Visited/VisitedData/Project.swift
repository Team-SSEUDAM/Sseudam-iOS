//
//  VisitedProject.swift
//
//  VisitedData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Visited,
  dependencies: [
    .Data.Visited.Interface,
  ]
)


