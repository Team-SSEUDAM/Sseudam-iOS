//
//  NMReverseGeocodingProject.swift
//
//  NMReverseGeocodingData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Data.NMReverseGeocoding,
  dependencies: [
    .Data.NMReverseGeocoding.Interface,
  ]
)


