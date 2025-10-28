//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 6/28/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Feature.Umbrella,
  dependencies: [
    .Features.Home,
    .Features.MyPet,
    .Features.Report,
    .Features.TrashDetail,
    .Features.Auth,
    .Features.SelectSpotCategory,
    .Features.SelectSpotImage,
    .Features.SelectSpotLocation,
    .Features.SelectSpotName,
    .Features.MyPage,
    .Features.Visited,
    .Features.Attendance,
    .Features.LevelUp,
    .Features.Notification
  ]
)


