//
//  ReportProject.swift
//
//  ReportData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Data.Report,
  dependencies: [
    .Data.Report.Interface,
  ]
)


