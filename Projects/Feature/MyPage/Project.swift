//
//  MyPageProject.swift
//
//  MyPage
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.MyPage,
  dependencies: [
    .Domain.Umbrella
  ]
)

