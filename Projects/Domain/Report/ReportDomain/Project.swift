//
//  ReportProject.swift
//
//  ReportDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Report,
  dependencies: [
    .Domain.Report.Interface
  ]
)

