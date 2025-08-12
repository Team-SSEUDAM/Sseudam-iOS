//
//  HistoryProject.swift
//
//  HistoryData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.History,
  dependencies: [
    .Data.History.Interface,
  ]
)


