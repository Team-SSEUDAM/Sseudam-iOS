//
//  HistoryProject.swift
//
//  HistoryDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.History,
  dependencies: [
    .Domain.History.Interface
  ]
)

