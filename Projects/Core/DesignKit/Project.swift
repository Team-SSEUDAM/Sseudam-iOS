//
//  Project.swift
//  Manifests
//
//  Created by 조용인 on 6/16/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DesignKit",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "DesignKit",
      destinations: .iOS,
      product: .framework,
      bundleId: "Sseudam.a2bo.ios.core.designKit",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"],
      resources: ["Resources/**"]
    )
  ],
  resourceSynthesizers: [
    .assets(),
    .fonts()
  ]
)
