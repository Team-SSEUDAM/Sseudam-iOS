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
    "NSLocationWhenInUseUsageDescription": "지도에서 내 위치를 확인하여 길찾기, 네비게이션 기능을 이용하기 위해 권한이 필요합니다.(필수권한)",
    "NMCLIENTID": "$(NM_CLIENT_ID)",

  ],
  dependencies: [
    .Features.Home,
    .Domain.Home.Implement,
    .Data.Home.Implement
  ]
)
