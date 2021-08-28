// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SS58Factory",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SS58AddressFactory",
            targets: ["SS58Factory"]),
        .library(name: "Blake2bFactory",
            targets: ["Blake2bFool"])
    ],
    dependencies: [
        .package(url: "https://github.com/tesseract-one/UncommonCrypto", from: "0.1.3"),
        .package(url: "https://github.com/tesseract-one/Blake2.swift", from: "0.1.2")
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SS58Factory",
            dependencies: ["Blake2bFool"]),
        .target(name: "Blake2bFool",
                dependencies: ["UncommonCrypto","Blake2"]
            ),
    ]
)
