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
    // TODO: - 추후 TrashSpot으로 변경 예정
    .Domain.Home.Interface
  ]
)

