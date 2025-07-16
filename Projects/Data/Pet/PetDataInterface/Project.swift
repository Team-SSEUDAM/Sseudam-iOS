//
//  PetProject.swift
//
//  PetData
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Pet,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


