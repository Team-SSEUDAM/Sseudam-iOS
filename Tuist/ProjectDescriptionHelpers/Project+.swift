//
//  Project+.swift
//  Packages
//
//  Created by 조용인 on 5/9/25.
//
import Foundation
import ProjectDescription

public extension Project {
  /// Dynamic Framework Project를 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  static func makeDynamicFrameworkProject<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Project {
    let name = name(for: module, suffix: nameSuffix)
    
    let framework = Target.makeDynamicFrameworkTarget(
      for: module,
      dependencies: dependencies,
      nameSuffix: nameSuffix
    )
    
    return baseProject(name: name, targets: [framework])
  }
  
  /// Static Library Project를 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록
  static func makeStaticLibraryProject<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = [],
    nameSuffix: String = ""
  ) -> Project {
    let name = name(for: module, suffix: nameSuffix)
    
    let library = Target.makeStaticLibraryTarget(
      for: module,
      dependencies: dependencies,
      nameSuffix: nameSuffix
    )
    
    let tests = Target.makeTestingTarget(
      for: module,
      dependencies: [.target(name: name)]
    )
    
    return baseProject(name: name, targets: [library, tests])
  }
  
  /// Feature 모듈을 위한 `Demo`, `Feature`, `Feature Unit Test`, `Feature Interface` Target들을 생성하는 메서드
  ///
  /// - Parameters:
  ///   - module: 모듈을 나타내는 `ModuleRepresentable` 타입
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: [])
  ///
  /// - `Demo`: Feature 모듈을 실행할 수 있는 앱 Target
  /// - `Feature`: Feature 모듈의 구현을 포함하는 Static Library Target
  /// - `Feature Unit Test`: Feature 모듈의 단위 테스트를 포함하는 Target
  /// - `Feature Interface`: Feature 모듈의 인터페이스를 포함하는 Dynamic Framework Target
  static func makeFeature<T: ModuleRepresentable>(
    for module: T,
    dependencies: [TargetDependency] = []
  ) -> Project {
    let demo = Target.makeDemoTarget(
      for: module,
      dependencies: [.target(name: name(for: module))]
    )
    let feature = Target.makeStaticLibraryTarget(
      for: module,
      dependencies: dependencies
    )
    let featureUnitTest = Target.makeTestingTarget(
      for: module,
      dependencies: [.target(name: name(for: module))]
    )
    return baseProject(
      name: name(for: module),
      targets: [demo, feature, featureUnitTest]
    )
  }
  
  /// App Project를 생성하는 메서드
  ///
  /// - Parameters:
  ///   - infoPlist: Info.plist 설정 (기본값: 빈 딕셔너리)
  ///   - dependencies: Target이 의존하는 다른 Target들의 목록 (기본값: 빈 배열)
  ///
  /// - `{Sample}`: Release 환경을 위한 App Target
  /// - `{Sample}_Develop`: Develop 환경을 위한 App Target
  static func makeApp(
    infoPlist: [String: Plist.Value] = [:],
    dependencies: [TargetDependency] = []
  ) -> Project {
    let releaseApp = Target.makeApp(
      name: "Sseudam",
      env: .release,
      infoPlist: infoPlist,
      dependencies: dependencies
    )
    let debugApp = Target.makeApp(
      name: "Sseudam_develop",
      env: .develop,
      infoPlist: infoPlist,
      dependencies: dependencies
    )
    return baseProject(
      name: "Sseudam",
      targets: [releaseApp, debugApp]
    )
  }
  
  /// 프로젝트 이름 생성 (`ModuleRepresentable` + 접미사)
  private static func name<T: ModuleRepresentable>(
    for module: T,
    suffix: String = ""
  ) -> String {
    return module.rawValue + module.typePath + suffix /// 예: `Sample`+ `Feature` + `Interface`
  }
  
  /// 공통 Project 초기화
  private static func baseProject(
    name: String,
    targets: [Target]
  ) -> Project {
    return .init(
      name: name,
      organizationName: organization,
      options: .default,
      settings: .default,
      targets: targets
    )
  }
}
