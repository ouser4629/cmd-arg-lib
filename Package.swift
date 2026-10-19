// Copyright (c) 2025-2026 Peter Summerland LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// swift-tools-version: 6.2

import CompilerPluginSupport
import PackageDescription

// By default, only include example that use the protocol API. The
// macro-based examples can sometimes compile very slowly on the first
// build.
let includeProtocolBasedCode = true
var includeMacroBasedCode = false

// Include the samples that use CmdArgMacros only when built with
// Swift 6.2 or later. Earlier toolchains either do not support macros
// or have unacceptable macro build performance.
#if compiler(<6.2)
    includeMacroBasedCode = false
}
#endif

// Products
var products: [Product] = []
if includeProtocolBasedCode {
    products += [
        .executable(name: "print-s", targets: ["Ex01_PrintStructAPI"]),
        .executable(name: "person-s", targets: ["Ex02_PersonStructAPI"]),
        .executable(name: "run-s", targets: ["Ex03_RunStructAPI"]),
        .executable(name: "advice-s", targets: ["Ex04_AdviceStructAPI"]),
        .executable(name: "sed-s", targets: ["Ex05_SedStructAPI"]),
    ]
}
if includeMacroBasedCode {
    products += [
        .executable(name: "print-m", targets: ["Ex01_PrintMacrosAPI"]),
        .executable(name: "person-m", targets: ["Ex02_PersonMacrosAPI"]),
        .executable(name: "run-m", targets: ["Ex03_RunMacrosAPI"]),
        .executable(name: "advice-m", targets: ["Ex04_AdviceMacrosAPI"]),
        .executable(name: "sed-m", targets: ["Ex05_SedMacrosAPI"]),
    ]
}

// Dependencies
var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/ouser4629/CmdArgParser.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgHelpScreen.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgManpage.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgCompletions.git", branch: "main"),
    .package(url: "https://github.com/ouser4629/CmdArgTestSupport.git", branch: "main"),
]
if includeMacroBasedCode {
    dependencies.append(.package(url: "https://github.com/ouser4629/CmdArgMacros.git", branch: "main"))
}

// Shared targets
var targets: [Target] = [
    .target(
        name: "Ex02_PersonShared",
        dependencies: [ "CmdArgParser", "CmdArgHelpScreen", "CmdArgCompletions"],
        path: "Sources/Ex02_Person/Shared"
    ),
    //
    .target(
        name: "Ex03_RunShared",
        dependencies: [ "CmdArgParser", "CmdArgHelpScreen", "CmdArgCompletions", ],
        path: "Sources/Ex03_Run/Shared"
    ),
    //
    .target(
        name: "Ex04_AdviceShared",
        dependencies: [ "CmdArgParser", "CmdArgCompletions",],
        path: "Sources/Ex04_Advice/Shared"
    ),
    //
    .target(
        name: "Ex05_SedShared",
        dependencies: [ "CmdArgParser", "CmdArgHelpScreen", "CmdArgManpage", ],
        path: "Sources/Ex05_Sed/Shared"
    ),
]

// Struct-base API targets
if includeProtocolBasedCode {
    targets += [
        .executableTarget(
            name: "Ex01_PrintStructAPI",
            dependencies: [ "CmdArgParser", "CmdArgHelpScreen",],
            path: "Sources/Ex01_Print/StructAPI"
        ),
        //
        .executableTarget(
            name: "Ex02_PersonStructAPI",
            dependencies: [ "CmdArgParser", "Ex02_PersonShared", "CmdArgCompletions"],
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
            dependencies: ["CmdArgParser", "CmdArgCompletions", "Ex03_RunShared"],
            path: "Sources/Ex03_Run/StructImplementation"
        ),
        .testTarget(
            name: "Ex03_RunStructTests",
            dependencies: ["CmdArgParser", "CmdArgTestSupport", "Ex03_RunStructImplementation",],
            path: "Tests/Ex03Tests/Ex03_StructTests"
        ),
        //
        .executableTarget(
            name: "Ex04_AdviceStructAPI",
            dependencies: [ "CmdArgParser", "CmdArgHelpScreen", "CmdArgCompletions", "Ex04_AdviceShared"],
            path: "Sources/Ex04_Advice/StructAPI"
        ),
        //
        .executableTarget(
            name: "Ex05_SedStructAPI",
            dependencies: [ "CmdArgParser", "Ex05_SedShared"],
            path: "Sources/Ex05_Sed/StructAPI"
        ),
    ]
}

// Macro-based API targets
if includeMacroBasedCode {
    targets += [
        .executableTarget(
            name: "Ex01_PrintMacrosAPI",
            dependencies: [ "CmdArgParser", "CmdArgMacros", "CmdArgHelpScreen",],
            path: "Sources/Ex01_Print/MacrosAPI"
        ),
        //
        .executableTarget(
            name: "Ex02_PersonMacrosAPI",
            dependencies: [ "CmdArgParser", "CmdArgMacros", "Ex02_PersonShared", "CmdArgCompletions"],
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
            dependencies: ["CmdArgParser", "CmdArgMacros", "CmdArgCompletions", "Ex03_RunShared"],
            path: "Sources/Ex03_Run/MacrosImplementation"
        ),
        .testTarget(
            name: "Ex03_RunMacrosTests",
            dependencies: ["CmdArgParser", "CmdArgTestSupport", "Ex03_RunMacrosImplementation", ],
            path: "Tests/Ex03Tests/Ex03_MacrosTests"

        ),
        //
        .executableTarget(
            name: "Ex04_AdviceMacrosAPI",
            dependencies: [ "CmdArgParser", "CmdArgMacros", "CmdArgHelpScreen", "CmdArgCompletions", "Ex04_AdviceShared"],
            path: "Sources/Ex04_Advice/MacrosAPI"
        ),
        //
        .executableTarget(
            name: "Ex05_SedMacrosAPI",
            dependencies: [ "CmdArgParser", "CmdArgMacros", "Ex05_SedShared"],
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
