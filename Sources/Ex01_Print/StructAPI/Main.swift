//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import CmdArgLibHelpScreen

@main
struct Main: CommandNodeStruct {
    typealias Phrase = String
    
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var count: Int = 1
    var phrase: Phrase? = nil

    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "print-s1",
        shadowGroups: ["u l"],
        embellishments: [
            .embellish("help", label: "h__help"),
            .embellish("phrase", label: "_", typeName: "Phrase?"),
        ]
    )

    func run(state: [Void]) throws -> [Void] {
        guard count >= 1 else { throw Exception.error("count must be >= 1") }
        let line = u ? phrase!.uppercased() : l ? phrase!.lowercased() : phrase!
        for _ in 1...count { print(line) }
        return []
    }

    private static let helpLayout: [ShowElement] = [
        .text("DESCRIPTION\n", "Print a $D{phrase} multiple times."),
        .synopsis("\nUSAGE\n"),
        .text("\nPARAMETERS"),
        .parameter("help", "Show help information"),
        .parameter("l", "Lowercase the output"),
        .parameter("u", "Uppercase the output"),
        .parameter("count", "The number of times to print the $D{phrase}"),
        .parameter("phrase", "The $D{phrase} to print"),
        .text("\nNOTE\n", "The $S{l} and $S{u} flags shadow each other. The last one specified takes precedence."),
    ]
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


