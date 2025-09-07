//
//  Project.swift
//  AppVersionDataInterfaceManifests
//
//  Created by 조용인 on 9/3/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "AnalyticsKit",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "AnalyticsKit",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.core.analyticsKit",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"],
      dependencies: [
        .Shared.Umbrella
      ]
    )
  ]
)
