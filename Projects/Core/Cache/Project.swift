//
//  Project.swift
//  AuthDataInterfaceManifests
//
//  Created by 조용인 on 7/3/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Cache",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "Cache",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.core.Cache",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"],
      dependencies: [
        .Shared.Umbrella
      ]
    )
  ]
)
