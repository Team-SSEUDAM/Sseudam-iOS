//
//  Project.swift
//  KeyChainManifests
//
//  Created by Jiyeon on 6/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeInternalLibraryProject(
  for: Shared.ThirdParty,
  dependencies: [
    .SPM.TCA
  ]
)

