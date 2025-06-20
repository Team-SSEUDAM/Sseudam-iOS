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
    .Shared.ThirdParty,
    .Shared.Utility
  ],
  nameSuffix: "Interface"
)
