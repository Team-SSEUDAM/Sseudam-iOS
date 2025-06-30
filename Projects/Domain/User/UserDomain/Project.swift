//
//  UserProject.swift
//
//  UserDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.User,
  dependencies: [
    .Domain.User.Interface
  ]
)

