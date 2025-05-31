//
//  SampleProject.swift
//
//  SampleDomainInterface
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDynamicFrameworkProject(
  for: Domain.Sample,
  dependencies: [
    .Domain.Sample.Interface
  ]
)
