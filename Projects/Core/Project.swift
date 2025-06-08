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
    )
//    .target(
//      name: "Cache",
//      destinations: .iOS,
//      product: .staticLibrary,
//      bundleId: "Sseudam.a2bo.ios.core.cache",
//      deploymentTargets: .iOS("17.0"),
//      infoPlist: .extendingDefault(with: [:]),
//      sources: ["./DesignKit/Sources/**"]
//    )
  ],
  resourceSynthesizers: [
    .assets(),
    .fonts()
  ]
)
