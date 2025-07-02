//
//  SuggestionProject.swift
//
//  SuggestionData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Suggestion,
  dependencies: [
    .Data.Suggestion.Interface,
  ]
)


