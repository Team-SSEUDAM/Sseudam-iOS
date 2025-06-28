//
//  SuggestionProject.swift
//
//  SuggestionDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Suggestion,
  dependencies: [
    .Domain.Suggestion.Interface
  ]
)

