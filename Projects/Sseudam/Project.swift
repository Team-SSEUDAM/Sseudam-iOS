//
//  Project.swift
//  Packages
//
//  Created by Jiyeon on 6/5/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeApp(
  infoPlist: [
    "CFBundleDevelopmentRegion": "ko_KR",
    "CFBundleShortVersionString": "1.0.0",
    "CFBundleVersion": "1",
    "CFBundleIconName": "AppIcon",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
      "UIApplicationSupportsMultipleScenes": false,
      "UISceneConfigurations": []
    ],
    "UISupportedInterfaceOrientations": [
      "UIInterfaceOrientationPortrait"
    ],
  ],
  dependencies: [
    .SPM.TCA,
    .Core.DesignKit
  ]
)
