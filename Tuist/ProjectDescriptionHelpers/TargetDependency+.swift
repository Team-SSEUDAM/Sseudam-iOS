//
//  TargetDependency+.swift
//  Packages
//
//  Created by 조용인 on 5/9/25.
//

import Foundation
import ProjectDescription

public protocol ModuleRepresentable: RawRepresentable where RawValue == String {
  var typePath: String { get }
}

public enum Module {
  case feature(Feature, isInterface: Bool = false)
  case domain(Domain, isInterface: Bool = false)
  case data(Data, isInterface: Bool = false)
  case core(Core)
  case spm(SPM)
}

public enum Feature: String, ModuleRepresentable {
  case Sample
  public var typePath: String { "Feature" }
}

public enum Domain: String, ModuleRepresentable {
  case Sample
  public var typePath: String { "Domain" }
}

public enum Data: String, ModuleRepresentable {
  case Sample
  public var typePath: String { "Data" }
}

public enum Core: String, ModuleRepresentable {
  case DesignKit
  public var typePath: String { "Core" }
}

public enum SPM: String, ModuleRepresentable {
  case TCA = "ComposableArchitecture"
  public var typePath: String { "SPM" }
}

protocol TargetDependencyDelegate { }

extension TargetDependencyDelegate {
  public static func project(_ module: Module) -> TargetDependency {
    switch module {
    case let .feature(feature, isInterface): return makeProjectDependency(for: feature, isInterface: isInterface)
    case let .domain(domain, isInterface): return makeProjectDependency(for: domain, isInterface: isInterface)
    case let .data(data, isInterface): return makeProjectDependency(for: data, isInterface: isInterface)
    case let .core(core): return makeProjectDependency(for: core)
    case let .spm(spm): return makeSPMDependency(for: spm)
    }
  }
  
  private static func makeProjectDependency<T: ModuleRepresentable>(
    for target: T,
    isInterface: Bool = false
  ) -> TargetDependency {
    let suffix = isInterface ? "Interface" : ""
    return .project(
      target: "\(target.rawValue)\(suffix)",
      path: .relativeToRoot("./Projects/\(target.typePath)/\(target.rawValue)")
    )
  }
  
  public static func makeSPMDependency(for target: SPM) -> TargetDependency {
    return .external(name: target.rawValue)
  }
}

/// `TargetDependencyDelegate`를 채택하는 중첩 Struct를 사용하여,
/// 실제 `dependency`를 사용하기 위한 편리한 접근 방식을 제공합니다.
///
/// - 예시:
/// ```swift
/// extension TargetDependency {
///   public struct Feature: TargetDependencyDelegate {
///     public struct Sample: TargetDependencyDelegate {
///       public static let Interface = Self.project(.feature(.Sample, isInterface: true))
///       public static let Implement = Self.project(.feature(.Sample))
///     }
///   }
/// }
///
/// let sampleInterface = TargetDependency.Features.Sample.Interface
/// let sampleImplement = TargetDependency.Features.Sample.Implement
/// ```

