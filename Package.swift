// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SS58Factory",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SS58Factory",
            targets: ["SS58Factory"]),
        .library(name: "Blake2bFactory",
            targets: ["Blake2bFool"]),
        .library(name: "SubstrateScrypt", targets: ["SubstrateScrypt"])
    ],
    dependencies: [
        .package(name: "scrypt", url: "https://github.com/v57/scrypt.c.git", from: "0.1.1"),
        .package(name: "Blake2", url: "https://github.com/tesseract-one/Blake2.swift.git", from: "0.1.2"),
        .package(name: "UncommonCrypto", url: "https://github.com/lishuailibertine/UncommonCrypto.swift", from: "0.1.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SS58Factory",
            dependencies: ["Blake2bFool","SubstrateScrypt"]),
        .target(name: "Blake2bFool",
                dependencies: ["Blake2","UncommonCrypto"]
            ),
        .target(name: "SubstrateScrypt",dependencies: ["scrypt"]),
    ]
)
