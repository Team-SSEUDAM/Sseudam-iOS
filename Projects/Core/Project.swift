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
      bundleId: "Sseudam.a2bo.ios.core.designKit",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["./DesignKit/Sources/**"],
      resources: ["./DesignKit/Resources/**"]
    ),
    .target(
      name: "DesignKitDemo",
      destinations: .iOS,
      product: .framework,
      bundleId: "Sseudam.a2bo.ios.core.designKitDemo",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["./DesignKit/Demo/Sources/**"],
      dependencies: [
        .Core.DesignKit
      ]
    )
  ],
  resourceSynthesizers: [
    .assets(),
    .fonts()
  ]
)
