//
//  HomeProject.swift
//
//  HomeDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.Home,
  dependencies: [
    .Domain.Home.Interface
  ]
)

