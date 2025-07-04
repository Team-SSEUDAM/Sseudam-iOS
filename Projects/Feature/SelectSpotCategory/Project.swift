//
//  SelectSpotCategoryProject.swift
//
//  SelectSpotCategory
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.SelectSpotCategory,
  dependencies: [
    .Domain.Umbrella
  ]
)

