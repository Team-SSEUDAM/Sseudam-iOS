//
//  ReportProject.swift
//
//  Report
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Report,
  dependencies: [
    .Features.SelectSpotCategory,
    .Features.SelectSpotImage,
    .Features.SelectSpotLocation,
    .Features.SelectSpotName,
    .Features.SpotSuggestionComplete,
    .Domain.Umbrella
  ]
)

