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
    "CFBundleDisplayName": "쓰담",
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
    "NSCameraUsageDescription": "쓰레기통 사진을 촬영하여 업로드하기 위해 권한이 필요합니다.",
    "NSPhotoLibraryUsageDescription": "앱에서 사진을 선택하기 위해 갤러리 접근 권한이 필요합니다.",
    "NMCLIENTID": "$(NM_CLIENT_ID)",
    "NMCLIENTSECRET": "$(NM_CLIENT_SECRET)",
    "BASE_URL": "$(BASE_URL)",
    "APP_STORE_URL": "$(APP_STORE_URL)",
    "FirebaseAppDelegateProxyEnabled": false,
    "MIXPANEL_TOKEN": "$(MIXPANEL_TOKEN)"
  ],
  dependencies: [
    .Features.Umbrella,
    .Data.Umbrella
  ]
)
