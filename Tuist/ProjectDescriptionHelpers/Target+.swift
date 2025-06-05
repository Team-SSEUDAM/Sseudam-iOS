//
//  Target+.swift
//  Packages
//
//  Created by 조용인 on 5/9/25.
//

import Foundation
import ProjectDescription

public let organization: String = "Sseudam.a2bo.ios"

public enum SchemeType: String {
  case develop = "Debug"
  case release = "Release"
  
  var entitlements: String { "Config/\(rawValue).entitlements" }
  var config: String { "Config/\(rawValue).xcconfig" }
  var bundleId: String { "Sseudam.a2bo.ios.\(rawValue)" }
  
}

public extension Target {
  
  // MARK: - App Target 생성
  static func makeApp(
    name: String,
    env: SchemeType,
    infoPlist: [String: Plist.Value] = [:],
    script: [TargetScript] = [],
    dependencies: [TargetDependency] = []
  ) -> Target {
    let config: Configuration = env == .develop
    ? .debug(name: .debug, xcconfig: .relativeToRoot(env.config))
    : .release(name: .release, xcconfig: .relativeToRoot(env.config))
    return target(
      name: name,
      destinations: [.iPhone],
      product: .app,
      bundleId: organization + ".\(env.rawValue)",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      entitlements: .file(path: .relativeToRoot(env.entitlements)),
      scripts: script,
      dependencies: dependencies,
      settings: .settings(
        configurations: [config]
      )
    )
  }
  
  /// Demo Target을 생성하는 메소드
  ///
  /// - Parameters:
  ///  - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///  - infoPlist: Target의 Info.plist 설정 (기본값: 빈 딕셔너리)
  ///  - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: 빈 배열)
  static func makeDemoTarget<T: ModuleRepresentable>(
    for module: T,
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Target {
    return makeModuleTarget(
      for: module,
      product: .app,
      nameSuffix: "Demo",
      infoPlist: infoPlist,
      dependencies: dependencies
    )
  }

  /// Dynamic Framework 타입의 Target을 생성하는 메소드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  ///   - nameSuffix: Target 이름에 추가할 접미사 (기본값: "")
  static func makeDynamicFrameworkTarget<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Target {
    makeModuleTarget(
      for: module,
      product: .framework,
      nameSuffix: nameSuffix,
      dependencies: dependencies
    )
  }

  /// Static Library 타입의 Target을 생성하는 메소드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  ///   - nameSuffix: Target 이름에 추가할 접미사 (기본값: "")
  static func makeStaticLibraryTarget<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Target {
    makeModuleTarget(
      for: module,
      product: .staticLibrary,
      nameSuffix: nameSuffix,
      dependencies: dependencies
    )
  }

  /// Testing: Unit Tests + Testing 접미사
  ///
  /// - Parameters:
  ///  - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///  - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  static func makeTestingTarget<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = []
  ) -> Target {
    makeModuleTarget(
      for: module,
      product: .unitTests,
      nameSuffix: "Testing",
      dependencies: dependencies
    )
  }

  /// 특정 모듈을 위한 Target을 생성하는 공통 메소드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - product: 생성할 Target의 `Product` 타입 (예: `.framework`, `.staticLibrary`, `.unitTests`)
  ///   - nameSuffix: Target 이름에 추가할 접미사 (기본값: "")
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  private static func makeModuleTarget<T: ModuleRepresentable>(
    for module: T,
    product: Product,
    nameSuffix: String = "",
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Target {
    let targetName = module.rawValue + module.typePath + nameSuffix
    let sourcesPath = module is Feature ? "./\(targetName)/Sources/**" : "./Sources/**"
    return target(
      name: targetName,
      destinations: .iOS,
      product: product,
      bundleId: "\(organization).\(targetName)",
      deploymentTargets: .iOS("17.0"),
      infoPlist: infoPlist == [:] ? .default : .extendingDefault(with: infoPlist),
      sources: ["\(sourcesPath)"],
      dependencies: dependencies
    )
  }
}
