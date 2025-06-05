//
//  Project.swift
//  SharedManifests
//
//  Created by Jiyeon on 6/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInternalLibraryProject(
  for: InternalLibrary.Shared,
  dependencies: [
    .Shared.ThirdParty
  ]
)

