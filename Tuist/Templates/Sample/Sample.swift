//
//  Sample.swift
//  Packages
//
//  Created by 조용인 on 5/27/25.
//

import Foundation
import ProjectDescription

fileprivate let fileName: Template.Attribute = .required("feature")
fileprivate let author: Template.Attribute = .required("author")

let SampleTemplate = Template(
  description: "Sample Project Template",
  attributes: [fileName, author],
  items: [
    .file(
      path: "Projects/\(fileName)/Project.swift",
      templatePath: "Sample.stencil"
    )
  ]
)

