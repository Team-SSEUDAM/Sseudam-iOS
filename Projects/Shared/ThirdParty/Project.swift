//
//  Project.swift
//  Manifests
//
//  Created by 조용인 on 6/16/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "ThirdParty",
  organizationName: "Sseudam.a2bo.ios",
  options: .default,
  settings: .default,
  targets: [
    .target(
      name: "ThirdParty",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.ThirdParty",
      deploymentTargets: .iOS("18.0"),
      infoPlist: .extendingDefault(with: [:]),
      sources: ["Sources/**"],
      dependencies: [
        .SPM.TCA,
        .SPM.NMapsMap,
        .SPM.DotLottie,
        .SPM.Mixpanel
      ]
    )
  ]
)

