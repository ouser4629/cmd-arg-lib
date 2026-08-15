//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

// Include desired examples
let includeStructBasedCode = true
var includeMacroBasedCode = true

// Include the samples that use CmdArgLibMacros only when built with
// Swift 6.2 or later. Earlier toolchains either do not support macros
// or have unacceptable macro build performance.
#if compiler(<6.2)
    includeMacroExamples = false
}
#endif

// Products
var products: [Product] = []
if includeStructBasedCode {
    products += [
        .executable(name: "print-s1", targets: ["Ex01_PrintStructAPI"]),
        .executable(name: "person-s", targets: ["Ex02_PersonStructAPI"]),
        .executable(name: "run-s", targets: ["Ex03_RunStructAPI"]),
        .executable(name: "advice-s", targets: ["Ex04_AdviceStructAPI"]),
        .executable(name: "sed-s", targets: ["Ex05_SedStructAPI"]),
    ]
}
if includeMacroBasedCode {
    products += [
        .executable(name: "print-m1", targets: ["Ex01_PrintMacrosAPI"]),
        .executable(name: "person-m", targets: ["Ex02_PersonMacrosAPI"]),
        .executable(name: "run-m", targets: ["Ex03_RunMacrosAPI"]),
        .executable(name: "advice-m", targets: ["Ex04_AdviceMacrosAPI"]),
        .executable(name: "sed-m", targets: ["Ex05_SedMacrosAPI"]),
    ]
}

// Dependencies
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/ouser4629/CmdArgLibCore.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibHelpScreen.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibManpage.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibCompletions.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgLibTestSupport.git", branch: "main"),
]
if includeMacroBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgLibMacros.git", branch: "main"))
}
if includeStructBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgLibCommandNodeStruct.git", branch: "main"))
}

// Shared targets
var targets: [Target] = [
    .target(
        name: "Ex02_PersonShared",
        dependencies: [ "CmdArgLibCore", "CmdArgLibHelpScreen", "CmdArgLibCompletions"],
        path: "Sources/Ex02_Person/Shared"
    ),
    //
    .target(
        name: "Ex03_RunShared",
        dependencies: [ "CmdArgLibCore", "CmdArgLibHelpScreen", "CmdArgLibCompletions", ],
        path: "Sources/Ex03_Run/Shared"
    ),
    //
    .target(
        name: "Ex04_AdviceShared",
        dependencies: [ "CmdArgLibCore", "CmdArgLibCompletions",],
        path: "Sources/Ex04_Advice/Shared"
    ),
    //
    .target(
        name: "Ex05_SedShared",
        dependencies: [ "CmdArgLibCore", "CmdArgLibHelpScreen", "CmdArgLibManpage", ],
        path: "Sources/Ex05_Sed/Shared"
    ),
]

// Struct-base API targets
if includeStructBasedCode {
    targets += [
        .executableTarget(
            name: "Ex01_PrintStructAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibCommandNodeStruct", "CmdArgLibHelpScreen",],
            path: "Sources/Ex01_Print/StructAPI"
        ),
        //
        .executableTarget(
            name: "Ex02_PersonStructAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibCommandNodeStruct", "Ex02_PersonShared", "CmdArgLibCompletions"],
            path: "Sources/Ex02_Person/StructAPI"
        ),
        //
        .executableTarget(
            name: "Ex03_RunStructAPI",
            dependencies: ["Ex03_RunStructImplementation",],
            path: "Sources/Ex03_Run/StructAPI"
        ),
        .target(
            name: "Ex03_RunStructImplementation",
            dependencies: ["CmdArgLibCore", "CmdArgLibCommandNodeStruct", "CmdArgLibCompletions", "Ex03_RunShared"],
            path: "Sources/Ex03_Run/StructImplementation"
        ),
        .testTarget(
            name: "Ex03_RunStructTests",
            dependencies: ["CmdArgLibCore", "CmdArgLibTestSupport", "Ex03_RunStructImplementation",],
            path: "Tests/Ex03Tests/Ex03_StructTests"
        ),
        //
        .executableTarget(
            name: "Ex04_AdviceStructAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibCommandNodeStruct", "CmdArgLibHelpScreen", "CmdArgLibCompletions", "Ex04_AdviceShared"],
            path: "Sources/Ex04_Advice/StructAPI"
        ),
        //
        .executableTarget(
            name: "Ex05_SedStructAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibCommandNodeStruct", "Ex05_SedShared"],
            path: "Sources/Ex05_Sed/StructAPI"
        ),
    ]
}

// Macro-based API targets
if includeMacroBasedCode {
    targets += [
        .executableTarget(
            name: "Ex01_PrintMacrosAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen",],
            path: "Sources/Ex01_Print/MacrosAPI"
        ),
        //
        .executableTarget(
            name: "Ex02_PersonMacrosAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibMacros", "Ex02_PersonShared", "CmdArgLibCompletions"],
            path: "Sources/Ex02_Person/MacrosAPI"
        ),
        //
        .executableTarget(
            name: "Ex03_RunMacrosAPI",
            dependencies: ["Ex03_RunMacrosImplementation"],
            path: "Sources/Ex03_Run/MacrosAPI"
        ),
        .target(
            name: "Ex03_RunMacrosImplementation",
            dependencies: ["CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibCompletions", "Ex03_RunShared"],
            path: "Sources/Ex03_Run/MacrosImplementation"
        ),
        .testTarget(
            name: "Ex03_RunMacrosTests",
            dependencies: ["CmdArgLibCore", "CmdArgLibTestSupport", "Ex03_RunMacrosImplementation", ],
            path: "Tests/Ex03Tests/Ex03_MacrosTests"

        ),
        //
        .executableTarget(
            name: "Ex04_AdviceMacrosAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibMacros", "CmdArgLibHelpScreen", "CmdArgLibCompletions", "Ex04_AdviceShared"],
            path: "Sources/Ex04_Advice/MacrosAPI"
        ),
        //
        .executableTarget(
            name: "Ex05_SedMacrosAPI",
            dependencies: [ "CmdArgLibCore", "CmdArgLibMacros", "Ex05_SedShared"],
            path: "Sources/Ex05_Sed/MacrosAPI"
        ),
    ]
}

// The package
let package = Package(
    name: "cmd-arg-lib",
    platforms: [.macOS(.v12)],
    products: products,
    dependencies: dependencies,
    targets: targets
)
