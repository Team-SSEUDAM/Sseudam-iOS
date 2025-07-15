//
//  MyPetProject.swift
//
//  MyPet
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.MyPet,
  dependencies: [
    .Features.Auth,
    .Domain.Umbrella
  ]
)

