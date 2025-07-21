//
//  VisitedProject.swift
//
//  Visited
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Visited,
  dependencies: [
    .Domain.Umbrella
  ]
)

