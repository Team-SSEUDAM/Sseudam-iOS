//
//  NMReverseGeocodingProject.swift
//
//  NMReverseGeocodingData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.NMReverseGeocoding,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


