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
    .Domain.Home.Interface
  ]
)

