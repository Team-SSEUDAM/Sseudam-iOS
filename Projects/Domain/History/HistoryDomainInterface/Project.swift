//
//  HistoryProject.swift
//
//  HistoryDomainInterface
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.History,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
