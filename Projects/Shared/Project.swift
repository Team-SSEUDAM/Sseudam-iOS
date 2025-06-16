//
//  Project.swift
//  CoreManifests
//
//  Created by 조용인 on 6/16/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Shared",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "Shared",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.core.shared",
      deploymentTargets: .iOS("17.0"),
      dependencies: [
        .Shared.ThirdParty,
        .Shared.Utility
      ]
    ),
    .target(
      name: "ThirdParty",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.core.thirdparty",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      dependencies: [
        .SPM.TCA,
        .SPM.NMapsMap
      ]
    ),
    .target(
      name: "Utility",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.Utility",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["./Utility/Sources/**"]
    )
  ]
)
