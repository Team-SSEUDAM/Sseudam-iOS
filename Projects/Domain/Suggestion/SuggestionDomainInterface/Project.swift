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
    .Domain.NMReverseGeocoding.Interface,
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
