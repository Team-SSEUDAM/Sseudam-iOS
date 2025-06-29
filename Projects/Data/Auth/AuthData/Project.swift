//
//  AuthProject.swift
//
//  AuthData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Data.Auth,
  dependencies: [
    .Data.Auth.Interface,
  ]
)


