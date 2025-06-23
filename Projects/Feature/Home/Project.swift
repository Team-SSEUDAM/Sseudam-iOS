//
//  HomeProject.swift
//
//  Home
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Home,
  dependencies: [
    .Features.Report,
    .Domain.Home.Interface
  ]
)

