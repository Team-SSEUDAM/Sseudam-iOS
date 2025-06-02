//
//  Data.swift
//  Templates
//
//  Created by Jiyeon on 6/2/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("feature")
fileprivate let author: Template.Attribute = .required("author")

/// 파일 경로
fileprivate let DataPath: String = "Projects/Data/\(name)"


let dataTemplate = Template(
  description: "Data Project Template",
  attributes: [
    name,
    author
  ],
  items: [
    // interface project
    .file(
      path: "\(DataPath)/\(name)DataInterface/Project.swift",
      templatePath: "data_project_interface.stencil"
    ),
    // dto
    .file(
      path: "\(DataPath)/\(name)DataInterface/Sources/Entity/\(name)Entity.swift",
      templatePath: "data_dto.stencil"
    ),
    // implement project
    .file(
      path: "\(DataPath)/\(name)Data/Project.swift",
      templatePath: "data_project_implement.stencil"
    ),
    // repository
    .file(
      path: "\(DataPath)/\(name)Data/Sources/\(name)RepositoryImpl.swift",
      templatePath: "data_repository.stencil"
    ),
    // test
    .file(
      path: "\(DataPath)/\(name)DataTesting/Sources/\(name)RepositoryTests.swift",
      templatePath: "data_tests.stencil"
    )
  ]
)
