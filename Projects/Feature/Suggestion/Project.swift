//
//  SuggestionProject.swift
//
//  Suggestion
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Suggestion,
  dependencies: [
    .Features.SelectSpotCategory,
    .Features.SelectSpotImage,
    .Features.SelectSpotLocation,
    .Features.SelectSpotName,
    .Domain.Umbrella
  ]
)

