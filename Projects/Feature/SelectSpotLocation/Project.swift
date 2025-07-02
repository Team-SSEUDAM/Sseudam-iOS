//
//  SelectSpotLocationProject.swift
//
//  SelectSpotLocation
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.SelectSpotLocation,
  dependencies: [
    .Domain.Umbrella
  ]
)

