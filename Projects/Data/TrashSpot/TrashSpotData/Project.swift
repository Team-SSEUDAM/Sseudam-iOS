//
//  TrashSpotProject.swift
//
//  TrashSpotData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.TrashSpot,
  dependencies: [
    .Data.TrashSpot.Interface,
  ]
)


