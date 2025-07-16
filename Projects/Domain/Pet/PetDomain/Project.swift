//
//  PetProject.swift
//
//  PetDomain
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Pet,
  dependencies: [
    .Domain.Pet.Interface
  ]
)

