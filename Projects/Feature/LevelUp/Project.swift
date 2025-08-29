//
//  LevelUpProject.swift
//
//  LevelUp
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.LevelUp,
  dependencies: [
    .Domain.Umbrella
  ]
)

