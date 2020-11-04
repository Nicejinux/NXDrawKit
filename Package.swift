// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "NXDrawKit",
    products: [
        .library(
            name: "NXDrawKit",
            targets: ["NXDrawKit"]
        )
    ],
    targets: [
        .target(
            name: "NXDrawKit",
            path: "NXDrawKit/"
        )
    ],
    swiftLanguageVersions: [.v5]
)
