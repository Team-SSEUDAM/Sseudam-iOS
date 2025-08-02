//
//  ImageDownloadProject.swift
//
//  ImageDownloadDomain
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.ImageDownload,
  dependencies: [
    .Domain.ImageDownload.Interface
  ]
)

