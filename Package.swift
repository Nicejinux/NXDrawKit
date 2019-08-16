// swift-tools-version:5.0
import PackageDescription

// swift-tools-version:4.0

let package = Package(
    name: "NXDrawKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "NXDrawKit",
            targets: ["NXDrawKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target defines a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "NXDrawKit",
            dependencies: []),
	    path: "NXDrawKit/Classes/",
        .testTarget(
            name: "NXDrawKitTests",
            dependencies: ["NXDrawKit"]),
    ]
)
