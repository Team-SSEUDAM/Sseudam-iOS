//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 6/24/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Shared.Umbrella,
  dependencies: [
    .Shared.KeyChain,
    .Shared.ThirdParty,
    .Shared.UserDefaults,
    .Shared.Utility
  ]
)
