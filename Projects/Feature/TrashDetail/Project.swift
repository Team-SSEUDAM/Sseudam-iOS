//
//  TrashDetailProject.swift
//
//  TrashDetail
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.TrashDetail,
  dependencies: [
    .Domain.Home.Interface
  ]
)

