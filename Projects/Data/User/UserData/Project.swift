//
//  UserProject.swift
//
//  UserData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Data.User,
  dependencies: [
    .Data.User.Interface,
  ]
)


