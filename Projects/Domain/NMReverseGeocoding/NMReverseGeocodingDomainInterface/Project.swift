//
//  NMReverseGeocodingProject.swift
//
//  NMReverseGeocodingDomainInterface
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.NMReverseGeocoding,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
