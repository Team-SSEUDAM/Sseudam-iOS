//
//  UserProject.swift
//
//  UserDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.User,
  dependencies: [
    .Domain.User.Interface
  ]
)

