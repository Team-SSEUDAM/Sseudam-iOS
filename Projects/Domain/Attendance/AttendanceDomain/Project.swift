//
//  AttendanceProject.swift
//
//  AttendanceDomain
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Domain.Attendance,
  dependencies: [
    .Domain.Attendance.Interface
  ]
)

