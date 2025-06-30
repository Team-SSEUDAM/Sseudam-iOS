//
//  AuthProject.swift
//
//  Auth
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Auth,
  dependencies: [
    .Domain.Auth.Interface,
    .Domain.User.Interface
  ]
)

