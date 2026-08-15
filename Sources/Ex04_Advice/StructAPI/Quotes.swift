//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import CmdArgLibCompletions
import CmdArgLibHelpScreen
import Foundation
import Ex04_AdviceShared

struct Quotes: CommandNodeStruct {
    var help: MetaFlag = MetaFlag(helpElements: helpElements)

    var configuration: CommandNodeConfiguration<TextStyle>? =  CommandNodeConfiguration<TextStyle>(
        commandName: "quotes",
        embellishments: [
            .embellish("help", label: "h__help"),
        ],
        commandSynopsis: "Print quotes by famous people.",
        children: [generalNode, computingNode]
    )

    func run(state: [TextStyle]) throws -> [TextStyle]
    {
        return state
    }

    private static let generalNode = GeneralQuotes.commandNode
    
    private static let computingNode = ComputingQuotes.commandNode

    private static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\n", "Print quotes by famous people."),
        .synopsis("\nUSAGE\n", line: ["help", "$_:Subcommand"]),
        .text("\nOPTION"),
        .parameter("help", "Show help information"),
        .text("\nSUBCOMMANDS"),
        .commandContext(generalNode.context),
        .commandContext(computingNode.context),
    ]
}
