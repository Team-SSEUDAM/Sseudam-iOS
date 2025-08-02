//
//  ImageDownloadProject.swift
//
//  ImageDownloadData
//
//  Created by JiYeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.ImageDownload,
  dependencies: [
    .Domain.Umbrella
  ],
  nameSuffix: "Interface"
)


