//
//  SpotSuggestionCompleteProject.swift
//
//  SpotSuggestionComplete
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.SpotSuggestionComplete,
  dependencies: [
    .Domain.Umbrella
  ]
)

