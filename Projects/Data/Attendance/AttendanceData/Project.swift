//
//  AttendanceProject.swift
//
//  AttendanceData
//
//  Created by Jiyeon
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeStaticLibraryProject(
  for: Data.Attendance,
  dependencies: [
    .Data.Attendance.Interface,
  ]
)


