//
//  ReportProject.swift
//
//  ReportData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Report,
  dependencies: [
    .Domain.Report.Interface
  ],
  nameSuffix: "Interface"
)


