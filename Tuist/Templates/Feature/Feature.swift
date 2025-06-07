//
//  Feature.swift
//  Templates
//
//  Created by Jiyeon on 5/30/25.
//

import Foundation
import ProjectDescription

fileprivate let name: Template.Attribute = .required("feature")
fileprivate let author: Template.Attribute = .required("author")

/// 파일 경로
fileprivate let FeaturePath: String = "Projects/Feature/\(name)"


let featureTemplate = Template(
  description: "Feature Project Template",
  attributes: [
    name,
    author
  ],
  items: [
    // project
    .file(
      path: "\(FeaturePath)/Project.swift",
      templatePath: "feature_project.stencil"
    ),
    // SwiftUI View
    .file(
      path: "\(FeaturePath)/\(name)Feature/Sources/\(name)View.swift",
      templatePath: "feature_view.stencil"
    ),
    // Reducer Interface
    .file(
      path: "\(FeaturePath)/\(name)FeatureInterface/Sources/\(name)Reducer.swift",
      templatePath: "feature_reducer_interface.stencil"
    ),
    // Reducer Implement
    .file(
      path: "\(FeaturePath)/\(name)Feature/Sources/\(name)Reducer.swift",
      templatePath: "feature_reducer_implement.stencil"
    ),
    // test
    .file(
      path: "\(FeaturePath)/\(name)FeatureTesting/Sources/\(name)UnitTests.swift",
      templatePath: "feature_test.stencil"
    ),
    // demo
    .file(
      path: "\(FeaturePath)/\(name)FeatureDemo/Sources/\(name)DemoApp.swift",
      templatePath: "feature_demo_app.stencil"
    ),
    // resources
    .file(
      path: "\(FeaturePath)/\(name)FeatureDemo/Resources/Assets.xcassets/Contents.json",
      templatePath: "feature_resources_contents.stencil"
    ),
    .file(
      path: "\(FeaturePath)/\(name)FeatureDemo/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json",
      templatePath: "feature_resources_appicon.stencil"
    )
  ]
)


