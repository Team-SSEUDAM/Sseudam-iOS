//
//  ImageDownloadProject.swift
//
//  ImageDownloadDomainInterface
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.ImageDownload,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
