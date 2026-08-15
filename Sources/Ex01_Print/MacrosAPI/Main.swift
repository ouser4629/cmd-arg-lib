//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen

@main
struct Main {
    typealias Phrase = String

    @MainFunctionMacro(shadowGroups: ["u l"])
    static public func printM1(
        h__help help: MetaFlag = MetaFlag(helpElements: helpLayout),
        l: Flag,
        u: Flag,
        count: Int = 1,
        _ phrase: Phrase) throws
    {
        guard count >= 1 else { throw Exception.error("count must be >= 1") }
        let line = u ? phrase.uppercased() : l ? phrase.lowercased() : phrase
        for _ in 1...count { print(line) }
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

