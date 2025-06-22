//
//  AuthProject.swift
//
//  AuthDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.Auth,
  dependencies: [
    .Domain.Auth.Interface
  ]
)

