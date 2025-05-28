//
//  Settings+.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 5/24/25.
//

import Foundation
import ProjectDescription

extension Settings {
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
