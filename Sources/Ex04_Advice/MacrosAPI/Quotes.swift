//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen
import CmdArgLibMacros
import Ex04_AdviceShared

struct Quotes {

    @CommandNodeMacro<TextStyle>(synopsis: "Print quotes by famous people.", children: childNodes)
    static func quotes(
        h__help help: MetaFlag = MetaFlag(helpElements: help),
        state: [TextStyle]) -> [TextStyle]
    {
        return state
    }

    private static let generalNode = GeneralQuotes.commandNode
    private static let computingNode = ComputingQuotes.commandNode
    private static let childNodes = [generalNode, computingNode]

    private static let help: [ShowElement] = [
        .text("DESCRIPTION\n", "Print quotes by famous people."),
        .synopsis("\nUSAGE\n", line: ["help", "$_:Subcommand"]),
        .text("\nOPTION"),
        .parameter("help", "Show help information"),
        .text("\nSUBCOMMANDS"),
        .commandContext(generalNode.context),
        .commandContext(computingNode.context),
    ]
}
