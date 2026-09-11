//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeFrame
import CmdArgLibHelpScreen

@main
struct Main: CommandNodeFrame {
    var h__help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var count: Int = 1
    var phrase: String? = nil

    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "print-s",
    )

    func run(state: [Void]) throws -> [Void] {
        guard count >= 1 else { throw Exception.error("count must be >= 1") }
        let line = u ? phrase!.uppercased() : l ? phrase!.lowercased() : phrase!
        for _ in 1...count { print(line) }
        return []
    }

    private static let helpLayout: [ShowElement] = [
        .text("DESCRIPTION\n", "Print a phrase multiple times."),
        .synopsis("\nUSAGE\n"),
        .text("\nPARAMETERS"),
        .parameter("h__help", "Show help information"),
        .parameter("l", "Lowercase the output"),
        .parameter("u", "Uppercase the output"),
        .parameter("count", "The number of times to print the phrase"),
        .parameter("phrase", "The phrase to print"),
    ]
}

