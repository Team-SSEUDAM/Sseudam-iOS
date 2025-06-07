//
//  HomeProject.swift
//
//  HomeData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Data.Home,
  dependencies: [
    .Data.Home.Interface,
  ]
)


