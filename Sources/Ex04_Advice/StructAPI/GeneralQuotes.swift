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

struct GeneralQuotes: CommandNodeStruct {
    var count: Int = 1
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)

    var configuration: CommandNodeConfiguration<TextStyle>? = CommandNodeConfiguration<TextStyle>(
        commandName: "general",
        embellishments: [
            .embellish("help", label: "h__help"),
        ], 
        commandSynopsis: "Print quotes about life in general.",
    )

    func run(state: [TextStyle]) throws -> [TextStyle]
    {
        if let TextStyle = state.first {
            try printCitedStringWith(TextStyle, count: count, stringAuthor: generalQuotes)
        }
        return []
    }

    private static let helpLayout: [ShowElement] = [
        .text("DESCRIPTION\n", "Print quotes about life in general."),
        .synopsis("\nUSAGE\n"),
        .text("\nOPTIONS"),
        .parameter("count", "The number of quotes to print"),
        .parameter("help","Show help information"),
    ]
}
