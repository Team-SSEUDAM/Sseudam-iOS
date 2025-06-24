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
  case feature(Feature)
  case domain(Domain, isInterface: Bool = false)
  case data(Data, isInterface: Bool = false)
  case core(Core)
  case shared(Shared)
  case spm(SPM)
}

public enum Feature: String, ModuleRepresentable {
  case Home
  case TrashDetail
  public var typePath: String { "Feature" }
}

public enum Domain: String, ModuleRepresentable {
  case Home
  public var typePath: String { "Domain" }
}

public enum Data: String, ModuleRepresentable {
  case Home
  public var typePath: String { "Data" }
}

public enum Core: String, ModuleRepresentable {
  case Umbrella = ""
  case DesignKit
  case NetworkKit
  public var typePath: String { "Core" }
}

public enum Shared: String, ModuleRepresentable {
  case Umbrella = ""
  case ThirdParty
  case Utility
  case KeyChain
  case UserDefaults
  public var typePath: String { "Shared" }
}

public enum SPM: String, ModuleRepresentable {
  case TCA = "ComposableArchitecture"
  case NMapsMap = "NMapsMap"
  public var typePath: String { "SPM" }
}

protocol TargetDependencyDelegate { }

extension TargetDependencyDelegate {
  public static func project(_ module: Module) -> TargetDependency {
    switch module {
    case let .feature(feature): return makeProjectDependency(for: feature, removeAddPath: true)
    case let .domain(domain, isInterface): return makeProjectDependency(for: domain, isInterface: isInterface)
    case let .data(data, isInterface): return makeProjectDependency(for: data, isInterface: isInterface)
    case let .core(core): return makeProjectDependency(for: core)
    case let .shared(shared): return makeProjectDependency(for: shared)
    case let .spm(spm): return makeSPMDependency(for: spm)
    }
  }
  
  /// Feature라면 `Projects/Feature/Sample`
  /// Domain이라면 `Projects/Domain/Sample/SampleDomainInterface` 또는 `Projects/Domain/Sample/SampleDomain`
  private static func makeProjectDependency<T: ModuleRepresentable>(
    for target: T,
    isInterface: Bool = false,
    removeAddPath: Bool = false
  ) -> TargetDependency {
    let suffix = isInterface ? "Interface" : ""
    let targetName = target.rawValue + target.typePath + suffix
    let addPath = removeAddPath ? "" : "/\(targetName)"
    return .project(
      target: targetName,
      path: .relativeToRoot("./Projects/\(target.typePath)/\(target)" + addPath)
    )
  }
  
  /// Core나 Shared는 `Projects/Core` 또는 `Projects/Shared`와 같이 경로가 단순합니다.
  private static func makeProjectDependency<T: ModuleRepresentable>(
    for target: T
  ) -> TargetDependency {
    let addPath = target.rawValue.isEmpty ? "" : "/\(target)"
    let targetName = target.rawValue.isEmpty ? target.typePath : target.rawValue
    return .project(
      target: "\(targetName)",
      path: .relativeToRoot("./Projects/\(target.typePath)\(addPath)")
    )
  }
  
  public static func makeSPMDependency(for target: SPM) -> TargetDependency {
    return .external(name: target.rawValue)
  }
    
}

extension TargetDependency {
  public struct Features: TargetDependencyDelegate {
    public static let Home = Self.project(.feature(.Home))
    public static let TrashDetail = Self.project(.feature(.TrashDetail))
  }
  
  public struct Domain: TargetDependencyDelegate {
    public struct Home: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Home, isInterface: true))
      public static let Implement = Self.project(.domain(.Home))
    }
  }
  
  public struct Data: TargetDependencyDelegate {
    public struct Home: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Home, isInterface: true))
      public static let Implement = Self.project(.data(.Home))
    }
  }
  
  public struct Core: TargetDependencyDelegate {
    public static let Umbrella = Self.project(.core(.Umbrella))
    public static let DesignKit = Self.project(.core(.DesignKit))
    public static let NetworkKit = Self.project(.core(.NetworkKit))
  }
  
  public struct Shared: TargetDependencyDelegate {
    public static let Umbrella = Self.project(.shared(.Umbrella))
    public static let ThirdParty = Self.project(.shared(.ThirdParty))
    public static let Utility = Self.project(.shared(.Utility))
    public static let KeyChain = Self.project(.shared(.KeyChain))
    public static let UserDefaults = Self.project(.shared(.UserDefaults))
  }
  
  public struct SPM: TargetDependencyDelegate {
    public static let TCA = Self.project(.spm(.TCA))
    public static let NMapsMap = Self.project(.spm(.NMapsMap))
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

