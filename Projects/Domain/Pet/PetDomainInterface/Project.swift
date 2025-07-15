//
//  PetProject.swift
//
//  PetDomainInterface
//
//  Created by yongin
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Pet,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
