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
  case shared(Shared)
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

public enum Shared: String, ModuleRepresentable {
  case ThirdParty
  public var typePath: String { "Shared" }
}

public enum SPM: String, ModuleRepresentable {
  case TCA = "ComposableArchitecture"
  public var typePath: String { "SPM" }
}

protocol TargetDependencyDelegate { }

extension TargetDependencyDelegate {
  public static func project(_ module: Module) -> TargetDependency {
    switch module {
    case let .feature(feature, isInterface): return makeProjectDependency(for: feature, isInterface: isInterface, removeAddPath: true)
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
  
  /// Core나 Shared는 `Projects/Core/DesignKit` 또는 `Projects/Shared/ThirdParty`와 같이 경로가 단순합니다.
  private static func makeProjectDependency<T: ModuleRepresentable>(
    for target: T
  ) -> TargetDependency {
    return .project(
      target: "\(target)",
      path: .relativeToRoot("./Projects/\(target.typePath)")
    )
  }
  
  public static func makeSPMDependency(for target: SPM) -> TargetDependency {
    return .external(name: target.rawValue)
  }
}

extension TargetDependency {
  public struct Features: TargetDependencyDelegate {
    public struct Sample: TargetDependencyDelegate {
      public static let Interface = Self.project(.feature(.Sample, isInterface: true))
      public static let Implement = Self.project(.feature(.Sample))
    }
  }
  
  public struct Domain: TargetDependencyDelegate {
    public struct Sample: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Sample, isInterface: true))
      public static let Implement = Self.project(.domain(.Sample))
    }
  }
  
  public struct Data: TargetDependencyDelegate {
    public struct Sample: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Sample, isInterface: true))
      public static let Implement = Self.project(.data(.Sample))
    }
  }
  
  public struct Core: TargetDependencyDelegate {
    public static let DesignKit = Self.project(.core(.DesignKit))
  }
  
  public struct Shared: TargetDependencyDelegate {
    public static let ThirdParty = Self.project(.shared(.ThirdParty))
  }
  
  public struct SPM: TargetDependencyDelegate {
    public static let TCA = Self.project(.spm(.TCA))
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

