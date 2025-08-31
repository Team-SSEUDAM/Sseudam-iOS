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
  case domain(Domain, isInterface: Bool? = false)
  case data(Data, isInterface: Bool? = false)
  case core(Core)
  case shared(Shared)
  case spm(SPM)
}

public enum Feature: String, ModuleRepresentable {
  case Umbrella = ""
  case Home
  case MyPet
  case TrashDetail
  case Auth
  case Report
  case SelectSpotLocation
  case SelectSpotName
  case SelectSpotCategory
  case SelectSpotImage
  case SpotSuggestionComplete
  case Suggestion
  case MyPage
  case Visited
  case Attendance
  case LevelUp
  public var typePath: String { "Feature" }
}

public enum Domain: String, ModuleRepresentable {
  case Umbrella = ""
  case Auth
  case User
  case NMReverseGeocoding
  case Suggestion
  case Report
  case TrashSpot
  case Pet
  case Visited
  case Attendance
  case ImageDownload
  case History
  case AppVersion
  public var typePath: String { "Domain" }
}

public enum Data: String, ModuleRepresentable {
  case Umbrella = ""
  case Auth
  case User
  case NMReverseGeocoding
  case Suggestion
  case Report
  case TrashSpot
  case Pet
  case Visited
  case Attendance
  case ImageDownload
  case History
  case AppVersion
  public var typePath: String { "Data" }
}

public enum Core: String, ModuleRepresentable {
  case Umbrella = ""
  case DesignKit
  case NetworkKit
  case Cache
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
  case DotLottie = "DotLottie"
  public var typePath: String { "SPM" }
}

protocol TargetDependencyDelegate { }

extension TargetDependencyDelegate {
  public static func project(_ module: Module) -> TargetDependency {
    switch module {
    case let .feature(feature):
      if feature == .Umbrella { return makeProjectDependency(for: feature) }
      return makeProjectDependency(for: feature, removeAddPath: true)
    case let .domain(domain, isInterface):
      if let isInterface = isInterface { return makeProjectDependency(for: domain, isInterface: isInterface) }
      return makeProjectDependency(for: domain)
    case let .data(data, isInterface):
      if let isInterface = isInterface { return makeProjectDependency(for: data, isInterface: isInterface) }
      return makeProjectDependency(for: data)
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
    public static let Umbrella = Self.project(.feature(.Umbrella))
    
    public static let Home = Self.project(.feature(.Home))
    public static let MyPet = Self.project(.feature(.MyPet))
    public static let Report = Self.project(.feature(.Report))
    public static let Suggestion = Self.project(.feature(.Suggestion))
    public static let SelectSpotLocation = Self.project(.feature(.SelectSpotLocation))
    public static let SelectSpotName = Self.project(.feature(.SelectSpotName))
    public static let SelectSpotCategory = Self.project(.feature(.SelectSpotCategory))
    public static let SelectSpotImage = Self.project(.feature(.SelectSpotImage))
    public static let SpotSuggestionComplete = Self.project(.feature(.SpotSuggestionComplete))
    public static let TrashDetail = Self.project(.feature(.TrashDetail))
    public static let Auth = Self.project(.feature(.Auth))
    public static let MyPage = Self.project(.feature(.MyPage))
    public static let Visited = Self.project(.feature(.Visited))
    public static let Attendance = Self.project(.feature(.Attendance))
    public static let LevelUp = Self.project(.feature(.LevelUp))
  }
  
  public struct Domain: TargetDependencyDelegate {
    public static let Umbrella = Self.project(.domain(.Umbrella, isInterface: nil))
    
    public struct Auth: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Auth, isInterface: true))
      public static let Implement = Self.project(.domain(.Auth))
    }
    public struct User: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.User, isInterface: true))
      public static let Implement = Self.project(.domain(.User))
    }
    public struct NMReverseGeocoding: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.NMReverseGeocoding, isInterface: true))
      public static let Implement = Self.project(.domain(.NMReverseGeocoding))
    }
    public struct Suggestion: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Suggestion, isInterface: true))
      public static let Implement = Self.project(.domain(.Suggestion))
    }
    public struct Report: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Report, isInterface: true))
      public static let Implement = Self.project(.domain(.Report))
    }
    public struct TrashSpot: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.TrashSpot, isInterface: true))
      public static let Implement = Self.project(.domain(.TrashSpot))
    }
    public struct Pet: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Pet, isInterface: true))
      public static let Implement = Self.project(.domain(.Pet))
    }
    public struct Visited: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Visited, isInterface: true))
      public static let Implement = Self.project(.domain(.Visited))
    }
    public struct Attendance: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.Attendance, isInterface: true))
      public static let Implement = Self.project(.domain(.Attendance))
    }
    public struct ImageDownload: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.ImageDownload, isInterface: true))
      public static let Implement = Self.project(.domain(.ImageDownload))
    }
    public struct History: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.History, isInterface: true))
      public static let Implement = Self.project(.domain(.History))
    }
    public struct AppVersion: TargetDependencyDelegate {
      public static let Interface = Self.project(.domain(.AppVersion, isInterface: true))
      public static let Implement = Self.project(.domain(.AppVersion))
    }
  }
  
  public struct Data: TargetDependencyDelegate {
    public static let Umbrella = Self.project(.data(.Umbrella, isInterface: nil))
    public struct Auth: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Auth, isInterface: true))
      public static let Implement = Self.project(.data(.Auth))
    }
    public struct User: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.User, isInterface: true))
      public static let Implement = Self.project(.data(.User))
    }
    public struct NMReverseGeocoding: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.NMReverseGeocoding, isInterface: true))
      public static let Implement = Self.project(.data(.NMReverseGeocoding))
    }
    public struct Suggestion: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Suggestion, isInterface: true))
      public static let Implement = Self.project(.data(.Suggestion))
    }
    public struct Report: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Report, isInterface: true))
      public static let Implement = Self.project(.data(.Report))
    }
    public struct TrashSpot: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.TrashSpot, isInterface: true))
      public static let Implement = Self.project(.data(.TrashSpot))
    }
    public struct Pet: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Pet, isInterface: true))
      public static let Implement = Self.project(.data(.Pet))
    }
    public struct Visited: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Visited, isInterface: true))
      public static let Implement = Self.project(.data(.Visited))
    }
    public struct Attendance: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.Attendance, isInterface: true))
      public static let Implement = Self.project(.data(.Attendance))
    }
    public struct ImageDownload: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.ImageDownload, isInterface: true))
      public static let Implement = Self.project(.data(.ImageDownload))
    }
    public struct History: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.History, isInterface: true))
      public static let Implement = Self.project(.data(.History))
    }
    public struct AppVersion: TargetDependencyDelegate {
      public static let Interface = Self.project(.data(.AppVersion, isInterface: true))
      public static let Implement = Self.project(.data(.AppVersion))
    }
  }
  
  public struct Core: TargetDependencyDelegate {
    public static let Umbrella = Self.project(.core(.Umbrella))
    public static let DesignKit = Self.project(.core(.DesignKit))
    public static let NetworkKit = Self.project(.core(.NetworkKit))
    public static let Cache = Self.project(.core(.Cache))
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
    public static let DotLottie = Self.project(.spm(.DotLottie))
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

