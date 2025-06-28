//
//  SuggestionProject.swift
//
//  SuggestionDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.Suggestion,
  dependencies: [
    .Domain.Suggestion.Interface
  ]
)

