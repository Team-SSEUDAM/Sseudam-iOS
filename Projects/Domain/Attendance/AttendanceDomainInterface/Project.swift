//
//  AttendanceProject.swift
//
//  AttendanceDomainInterface
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Attendance,
  dependencies: [
    .Core.Umbrella
  ],
  nameSuffix: "Interface"
)
