//
//  Project.swift
//  DesignKitManifests
//
//  Created by 조용인 on 6/24/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Core.Umbrella,
  dependencies: [
    .Core.DesignKit,
    .Core.NetworkKit,
    .Core.Cache
  ]
)


