//
//  TrashSpotProject.swift
//
//  TrashSpotDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.TrashSpot,
  dependencies: [
    .Domain.TrashSpot.Interface
  ]
)

