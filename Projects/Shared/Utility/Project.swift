//
//  Project.swift
//  SharedManifests
//
//  Created by Jiyeon on 6/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers
let project = Project(
  name: "Utility",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "Utility",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.Utility",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"],
      dependencies: [
      ]
    )
  ]
)
