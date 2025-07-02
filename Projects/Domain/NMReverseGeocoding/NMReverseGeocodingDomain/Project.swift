//
//  NMReverseGeocodingProject.swift
//
//  NMReverseGeocodingDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.NMReverseGeocoding,
  dependencies: [
    .Domain.NMReverseGeocoding.Interface
  ]
)

