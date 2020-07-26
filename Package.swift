// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SunCalc",
    platforms: [
        .iOS(.v8), .macOS(.v10_10), .watchOS(.v2), .tvOS(.v9)
    ],
    products: [
        .library(
            name: "SunCalc",
            targets: ["SunCalc"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "SunCalc",
            dependencies: [],
            path: "SwiftSunCalc"),
        /*,
        .testTarget(
            name: "",
            dependencies: [""],
            path: ""),*/
        ],
    swiftLanguageVersions: [ .v4_2, .v5 ]
)
