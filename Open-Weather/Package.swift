// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Open-Weather",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "CoreNetworking", targets: ["CoreNetworking"]),
        .library(name: "CoreModel", targets: ["CoreModel"]),
        .library(name: "CoreAssets", targets: ["CoreAssets"]),
        .library(name: "WeatherKit", targets: ["WeatherKit"]),
        .library(name: "WeatherUI", targets: ["WeatherUI"]),
        .library(name: "SearchKit", targets: ["SearchKit"]),
        .library(name: "SearchUI", targets: ["SearchUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        // MARK: - CoreNetworking
        
        .target(
            name: "CoreNetworking",
            dependencies: [],
            resources: [.process("Secrets")]
        ),
        .testTarget(
            name: "CoreNetworkingTests",
            dependencies: ["CoreNetworking"]
        ),
        
        // MARK: - CoreModel
        
        .target(
            name: "CoreModel",
            dependencies: []
        ),
        
        // MARK: - CoreAssets
        
        .target(
            name: "CoreAssets",
            dependencies: [],
            resources: [.process("Assets")]
        ),

        // MARK: - WeatherKit
        
        .target(
            name: "WeatherKit",
            dependencies: [
                "CoreNetworking",
                "CoreModel",
                "SearchKit"
            ]
        ),
        .testTarget(
            name: "WeatherKitTests",
            dependencies: [
                "CoreNetworking",
                "CoreModel",
                "WeatherKit"
            ],
            resources: [.process("JSON")]
        ),
        
        // MARK: - WeatherUI
        
        .target(
            name: "WeatherUI",
            dependencies: [
                "CoreAssets",
                "WeatherKit",
                "SearchUI"
            ]
        ),
        
        // MARK: - SearchKit
        
        .target(
            name: "SearchKit",
            dependencies: [
                "CoreNetworking",
                "CoreModel"
            ]
        ),
        .testTarget(
            name: "SearchKitTests",
            dependencies: [
                "CoreNetworking",
                "CoreModel",
                "SearchKit"
            ],
            resources: [.process("JSON")]
        ),
        
        // MARK: - SearchUI
        
        .target(
            name: "SearchUI",
            dependencies: ["SearchKit"]
        ),
    ]
)
