//
//  HomeProject.swift
//
//  HomeData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Home,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


