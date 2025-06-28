//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 6/28/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Feature.Umbrella,
  dependencies: [
    .Features.Home,
    .Features.Report,
    .Features.TrashDetail
  ]
)


