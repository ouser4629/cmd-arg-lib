//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.


import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibCompletions
import Ex02_PersonShared

@main
struct Main {
    typealias Shell = CompletionGenerator

    @MainFunctionMacro(shadowGroups: ["u l"])
    static func personM(
        h__help help: MetaFlag = MetaFlag(helpElements: helpLayout),
        l: Flag = false,
        u: Flag = false,
        c__count count: Int = 1,
        w__weight weight: Double? = nil,
        s__sonHas sonHas: Variadic<Pet> = [],
        d__daughterHas daughterHas: [Pet] = [],
        _ name: Name,
        generateCompletionScript: MetaOption<Shell> = MetaOption(generator))
    {
        var lines: [String] = []
        if let weight { lines.append("  \(name) weighs \(weight) kgs.") }
        if !sonHas.isEmpty  { lines.append("  \(name)'s son has \(sonHas.map{"a \($0)"}.joinedWith("and")).") }
        if !daughterHas.isEmpty  { lines.append("  \(name)'s daughter has \(daughterHas.map{"a \($0)"}.joinedWith("and")).") }
        if lines.isEmpty  { lines.append("  No data was found for \(name).") }
        if count < 0 { lines.reverse() }
        lines.insert("DATA:", at: 0)
        var line = lines.joined(separator: "\n")
        line = u ? line.uppercased() : l ? line.lowercased() : line
        for _ in 0..<abs(count) { print(line) }
    }
    
    static let generator = CompletionGenerator(name: "person-m", suggestionElements: helpLayout)
}

//  * Purpose
//   * Shows use of every `CmdArgTBasicType` provided "out of the box"
//   * Shows use of Array<B>, Variadic<B> and Optional<B> where B is a basic type
//   * Shows use of default values
//   * Shows use of typealias to customize placeholders in help screends, etc.
//   * Shows use of the help screen meta-flag initializer: `MetaFlag(helpElements:)`
//   * Shows use of the script generation type: `MetaOption<CompletionGenerator>`
//
// *  Imports
//   * CmdArgLibCore - for core functionality
//   * CmdArgLibMacros - the macro-based API
//   * CmdArgLIbCompletions - support for completion script generation
//   * Ex02_PersonShared - functionality shared with the struct-Based Implementation
//
// *  @MainFunctionMacro(shadowGroups: ["u l"])
//   * Annotates the command function, `toolM`
//   * Generates CLI code, including a static `main()` method called by the system
//   * The shadow group is a whitespace-separated list of parameter names. If more than
//     one of the named parameters is encountered during parsing of command arguments,
//     the last takes precedence.
//
// *  Each CLI argument is derived from a corresponding command function parameter
//   * Its label-spec is derived from the parameter's label
//   * Its type matches the parameter's type
//   * Its default value matches the parameter's default value
//   * Its type determines how it is parsed (no way to change this)
//   * Its type and default value determine how it appears in the library's standard help screen
//   * If a parameter has a default value, its corresponding argument optional,
//     otherwise it is required
//   * Flag is a typealias for Bool; it has an implied default value of `false`
//
// *  Parameters with type `MetaFlag` trigger meta-services like help screens, manual pages,
//    web-pages, completion scripts, etc.
//   * A meta-flag parameter must have a default value
//   * The default value has a function that is called when the meta-flag parameter is
//     encountered during parsing
//   * All meta-flag parameters automatically shadow each other
//   * If a meta-flag is encountered, and not shadowed, during parsing it will trigger - always
