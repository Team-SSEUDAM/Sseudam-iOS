//
//  ReportProject.swift
//
//  ReportDomainInterface
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Report,
  dependencies: [
    .Core.Umbrella,
    .Domain.TrashSpot.Interface
  ],
  nameSuffix: "Interface"
)
