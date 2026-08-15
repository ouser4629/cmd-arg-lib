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

struct ComputingQuotes {
    @CommandNodeMacro<TextStyle>(synopsis: "Print quotes about computing.")
    static func computing(
        count: Count = 1,
        h__help help: MetaFlag = MetaFlag(helpElements: help),
        state: [TextStyle]) throws
    {
        if let TextStyle = state.first {
            try printCitedStringWith(TextStyle, count: count, stringAuthor: computingQuotes)
        }
    }

    private static let help: [ShowElement] = [
        .text("DESCRIPTION\n", "Print quotes about computing."),
        .synopsis("\nUSAGE\n"),
        .text("\nOPTIONS"),
        .parameter("count", "The number of quotes to print"),
        .parameter("help","Show help information"),
    ]
}
