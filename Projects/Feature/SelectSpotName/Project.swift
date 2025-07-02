//
//  SelectSpotNameProject.swift
//
//  SelectSpotName
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.SelectSpotName,
  dependencies: [
    .Domain.Umbrella
  ]
)

