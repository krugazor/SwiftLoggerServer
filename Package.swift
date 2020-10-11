// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLogger",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .executable(name: "SwiftLoggerServer", targets: ["SwiftLoggerServer"]),
        .library(name: "SwiftLoggerRouter", targets: ["SwiftLoggerRouter"]),
        .library(name: "SwiftLoggerCommon", targets: ["SwiftLoggerCommon"]),
        .library(name: "SwiftLoggerClient", targets: ["SwiftLoggerClient"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Kitura", url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.9.1")),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftLoggerCommon",
            dependencies: []),
         .target(
            name: "SwiftLoggerRouter",
            dependencies: ["SwiftLoggerCommon", "Kitura"]),
        .target(name: "SwiftLoggerServer",
                dependencies: ["SwiftLoggerRouter", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .target(
            name: "SwiftLoggerClient",
            dependencies: ["SwiftLoggerCommon"]),
        .testTarget(
            name: "SwiftLoggerClientTests",
            dependencies: ["SwiftLoggerClient", "SwiftLoggerRouter"], resources: [.copy("../screenshot-terminal.png")]),

    ]
)
