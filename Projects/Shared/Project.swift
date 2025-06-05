//
//  Project.swift
//  SharedManifests
//
//  Created by Jiyeon on 6/5/25.
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
      name: "ThirdParty",
      destinations: .iOS,
      product: .staticLibrary,
      bundleId: "Sseudam.a2bo.ios.Shared",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: [:]),
      dependencies: [
        .SPM.TCA
      ]
    )
  ]
)
