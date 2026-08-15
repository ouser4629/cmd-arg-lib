//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import CmdArgLibCompletions
import Ex02_PersonShared

@main
struct Main: CommandNodeStruct {
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var count: Int = 1
    var weight: Double?? = nil
    var sonHas: Variadic<Pet> = []
    var daughterHas: [Pet] = []
    var name: Name? = nil
    var generateCompletionScript: MetaOption<CompletionGenerator> = MetaOption(generator)

    // Configuration
    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "person-s",
        shadowGroups: ["u l"],
        embellishments: [
            .embellish("help", label: "h__help"),
            .embellish("name", label: "_", typeName: "Name?"),
            .embellish("count", label: "c__count"),
            .embellish("weight", label: "w__weigth"),
            .embellish("sonHas", label: "s__sonHas", typeName: "Variadic<Pet>"),
            .embellish("daughterHas", label: "d__daughterHas"),
            .embellish("generateCompletionScript", typeName: "MetaOption<Shell>"),
        ],
    )

    func run(state: [Void]) -> [Void]
    {
        var lines: [String] = []
        if let weight, let weight { lines.append("  \(name!) weighs \(weight) kgs.") }
        if !sonHas.isEmpty  { lines.append("  \(name!)'s son has \(sonHas.map{"a \($0)"}.joinedWith("and")).") }
        if !daughterHas.isEmpty  { lines.append("  \(name!)'s daughter has \(daughterHas.map{"a \($0)"}.joinedWith("and")).") }
        if lines.isEmpty  { lines.append("  No data was found for \(name!).") }
        if count < 0 { lines.reverse() }
        lines.insert("DATA:", at: 0)
        var line = lines.joined(separator: "\n")
        line = u ? line.uppercased() : l ? line.lowercased() : line
        for _ in 0..<abs(count) { print(line) }
        return []
    }

    static let generator = CompletionGenerator(name: "person-s", suggestionElements: helpLayout)
}

// * Purpose
//   * Shows use of every `CmdArgTBasicType` provided "out of the box"
//   * Shows use of Array<B>, Variadic<B> and Optional<B> where B is a basic type
//   * Shows use of default values
//   * Shows use of the help screen meta-flag initializer: `MetaFlag(helpElements:)`
//   * Shows use of the script generation type: `MetaOption<Shell>`
//
// * Imports
//   * CmdArgLibCore - for core functionality
//   * CmdArgLibCommandNodeStruct - the struct-based API
//   * CmdArgLIbCompletions - support for completion script generation
//   * Ex02_PersonShared - functionality shared with the Struct-Based Implementation
//
// * The CLI is defined in a struct that conforms to `CommandNodeStruct`
//   * Each parameter's name, type, and default value are defined by a corresponding stored property
//   * The default label-spec is the property's name
//   * The default type-name is the property's base type (not the typealias, if any that refers to it)
//   * Every stored property must have an explicit default value
//   * If a property's default value is nil, the corresponding argument is required, otherwise it is not
//   * Accordingly, properties with type Optional<B:CmdArgBasicType> are guaranteed to be supplied with a non-nil value
//
// * The struct has a static property `configuration: Configuration`
//   * Defines the name of the command
//   * Defines shadow groups
//   * Embellishes the stored properties, adding a custom label-spec and/or a type-name
//
// * `CommandNodeStruct`
//   * provides a static var `commandNode: CommandNode` that returns a command node
//   * provides `static main()`, which calls the command node's `run` method, which in turn calls the struct's `run` method
//
// * The run(state) method
//   * Is called by the command node provided by the struct
//   * Performs program logic, based on command line arguments and state
//   * Returns state, which the command node can pass to child nodes
//   * For simple hierarchies and stand-alone commands, use [Void] for state, ignore it, and return []
