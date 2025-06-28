//
//  SuggestionProject.swift
//
//  SuggestionDomainInterface
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Suggestion,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
