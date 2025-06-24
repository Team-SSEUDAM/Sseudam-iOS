//
//  Project.swift
//  NetworkKitManifests
//
//  Created by 조용인 on 6/24/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "NetworkKit",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "NetworkKit",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.core.networkKit",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"]
    )
  ]
)
