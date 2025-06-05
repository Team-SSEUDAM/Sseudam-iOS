//
//  Project.swift
//  CoreManifests
//
//  Created by Jiyeon on 6/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Core",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "DesignKit",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.Core",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["./DesignKit/Sources/**"]
//      dependencies: [
//        .Core.ResourceKit
//      ]
    )
//    .target(
//      name: "ResourceKit",
//      destinations: .iOS,
//      product: .bundle,
//      bundleId: "Sseudam.a2bo.ios.ResourceKit",
//      deploymentTargets: .iOS("17.0"),
//      infoPlist: .extendingDefault(with: [:]),
//      resources: ["./Resources/**"]
//    )
  ]
)
