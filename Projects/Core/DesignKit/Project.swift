//
//  Project.swift
//  DesignKitManifests
//
//  Created by Jiyeon on 6/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInternalLibraryProject(
  for: Core.DesignKit,
  dependencies: [
    .InternalLibrary.Shared
  ]
)
