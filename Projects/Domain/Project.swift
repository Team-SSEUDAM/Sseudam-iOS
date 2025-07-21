//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 6/28/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Umbrella,
  dependencies: [
    .Domain.Report.Implement,
    .Domain.NMReverseGeocoding.Implement,
    .Domain.Suggestion.Implement,
    .Domain.Auth.Implement,
    .Domain.User.Implement,
    .Domain.TrashSpot.Implement,
    .Domain.Pet.Implement,
    .Domain.Visited.Implement
  ]
)
