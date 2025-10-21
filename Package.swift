// swift-tools-version:5.3

import Foundation
import PackageDescription

var sources = ["src/parser.c"]
if FileManager.default.fileExists(atPath: "src/scanner.c") {
    sources.append("src/scanner.c")
}

let package = Package(
    name: "TreeSitterGdshader",
    products: [
        .library(name: "TreeSitterGdshader", targets: ["TreeSitterGdshader"]),
    ],
    dependencies: [
        .package(name: "SwiftTreeSitter", url: "https://github.com/tree-sitter/swift-tree-sitter", from: "0.9.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterGdshader",
            dependencies: [],
            path: ".",
            sources: sources,
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("src")]
        ),
        .testTarget(
            name: "TreeSitterGdshaderTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterGdshader",
            ],
            path: "bindings/swift/TreeSitterGdshaderTests"
        )
    ],
    cLanguageStandard: .c11
)
