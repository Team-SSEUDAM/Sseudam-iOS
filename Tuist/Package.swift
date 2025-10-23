// swift-tools-version: 6.0
import PackageDescription

/// Tuist 환경에서만 적용되는 SPM 패키지 링크 타입 설정
///   - Tuist가 Xcode 워크스페이스를 생성할 때, `아래 product 이름을 동적 프레임워크(.framework)로 붙여 줍니다.`
#if TUIST
import struct ProjectDescription.PackageSettings
let packageSettings = PackageSettings(
  productTypes: [
    "ComposableArchitecture": .framework,
    "Dependencies": .framework,
    "Clocks": .framework,
    "ConcurrencyExtras": .framework,
    "CombineSchedulers": .framework,
    "IdentifiedCollections": .framework,
    "OrderedCollections": .framework,
    "_CollectionsUtilities": .framework,
    "DependenciesMacros": .framework,
    "SwiftUINavigationCore": .framework,
    "Perception": .framework,
    "IssueReporting": .framework,
    "CasePaths": .framework,
    "CustomDump": .framework,
    "XCTestDynamicOverlay": .framework,
    "PerceptionCore": .framework
  ]
)

#endif

/// SwiftPM이 이 디렉터리를 패키지로 인식하도록 하는 매니페스트
///   - 패키지 이름: `tuist-template`
///   - 외부 의존성: `PointFree`의 `ComposableArchitecture`
let package = Package(
  name: "tuist-template", /// 패키지 이름
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.20.1"),
    .package(url: "https://github.com/pointfreeco/swift-navigation.git", exact: "2.3.1"), /// swift-navigation 명시적 버전 지정
    .package(url: "https://github.com/navermaps/SPM-NMapsMap.git", exact: "3.21.0"),
    .package(url: "https://github.com/LottieFiles/dotlottie-ios", exact: "0.8.3"),
    .package(url: "https://github.com/mixpanel/mixpanel-swift", exact: "5.1.1")
  ]
)
