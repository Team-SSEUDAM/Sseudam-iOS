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
    .Domain.Umbrella
  ]
)

