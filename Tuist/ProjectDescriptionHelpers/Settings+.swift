//
//  Settings+.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 5/24/25.
//

import Foundation
import ProjectDescription

extension Settings {
  public static let release = Self.settings(
    base: [
      "DEVELOPMENT_TEAM": "6NXQDZ68FD",
      "CODE_SIGN_STYLE": "Manual",
      "PROVISIONING_PROFILE_SPECIFIER": "match Development Sseudam.a2bo.ios.Release",
      "CODE_SIGN_IDENTITY": "Apple Development: yongin cho (B2J2829PJ5)"
    ],
    configurations: [
      .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
      .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
    ]
  )
  
  public static let dev = Self.settings(
    base: [
      "DEVELOPMENT_TEAM": "6NXQDZ68FD",
      "CODE_SIGN_STYLE": "Manual",
      "PROVISIONING_PROFILE_SPECIFIER": "match Development Sseudam.a2bo.ios.Debug",
      "CODE_SIGN_IDENTITY": "Apple Development: yongin cho (B2J2829PJ5)"
    ],
    configurations: [
      .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
      .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
    ]
  )
  
  public static let `default` = Self.settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
  ])
}

extension Project.Options.TextSettings {
  public static let `default` = Self.textSettings(
    indentWidth: 2,
    tabWidth: 2,
    wrapsLines: true
  )
}

extension Project.Options {
  public static let `default` = Self.options(
    automaticSchemesOptions: .disabled,
    defaultKnownRegions: ["ko"],
    developmentRegion: "ko",
    textSettings: .default
  )
}
