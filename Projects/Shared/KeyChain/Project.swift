//
//  Project.swift
//  CoreManifests
//
//  Created by Jiyeon on 6/16/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "KeyChain",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "KeyChain",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.KeyChain",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"],
      dependencies: [
      ]
    )
  ]
)
