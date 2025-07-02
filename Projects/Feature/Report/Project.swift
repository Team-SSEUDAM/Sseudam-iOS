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
    .Domain.Umbrella
  ]
)

