//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 6/28/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Umbrella,
  dependencies: [
    .Data.Report.Implement,
    .Data.NMReverseGeocoding.Implement,
    .Data.Suggestion.Implement,
    .Data.Auth.Implement,
    .Data.User.Implement,
    .Data.TrashSpot.Implement,
    .Data.Pet.Implement,
    .Data.Visited.Implement,
    .Data.Attendance.Implement,
    .Data.ImageDownload.Implement,
    .Data.History.Implement,
    .Data.AppVersion.Implement,
    .Data.Notification.Implement
  ]
)


