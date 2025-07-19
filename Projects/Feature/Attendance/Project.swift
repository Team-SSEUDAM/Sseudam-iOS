//
//  AttendanceProject.swift
//
//  Attendance
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
  for: Feature.Attendance,
  dependencies: [
    .Domain.Umbrella
  ]
)

