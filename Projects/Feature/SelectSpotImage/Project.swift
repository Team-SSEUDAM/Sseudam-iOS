//
//  SelectSpotImageProject.swift
//
//  SelectSpotImage
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.SelectSpotImage,
  dependencies: [
    .Domain.Umbrella
  ]
)

