//
//  NMReverseGeocodingProject.swift
//
//  NMReverseGeocodingDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.NMReverseGeocoding,
  dependencies: [
    .Domain.NMReverseGeocoding.Interface
  ]
)

