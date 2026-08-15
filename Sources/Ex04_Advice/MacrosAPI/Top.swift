//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozillia.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCompletions
import CmdArgLibHelpScreen
import CmdArgLibMacros
import Ex04_AdviceShared

@main
struct Top {

    typealias Shell = CompletionGenerator

    @CommandNodeMacro<TextStyle>(synopsis: "Print quotes and book titles.", children: childNodes)
    static func adviceM(
        h__help help: MetaFlag = MetaFlag(helpElements: helpLayout),
        t__tree tree: MetaFlag = MetaFlag(treeFor: "advice-m", synopsis: ""),
        v__version version: MetaFlag = MetaFlag(string: "0.1.0"),
        generateCompletionScript script: MetaOption<Shell> = MetaOption(generator),
        l__lower lower: Flag,
        u__upper upper: Flag,
        c__color color: Color = .white,
        state: [TextStyle]) -> [TextStyle]
    {
        let textStyle = TextStyle(upper: upper, lower: lower, color: color)
        return [textStyle]
    }

    private static let booksNode = Books.commandNode
    private static let quotesNode = Quotes.commandNode
    private static let childNodes = [booksNode, quotesNode]

    static let generator = CompletionGenerator(name: "advice-m", suggestionElements: helpLayout)

    private static let helpLayout = sharedHelp + [
        .text("SUBCOMMANDS"),
        .commandContext(quotesNode.context),
        .commandContext(booksNode.context),
        .text("\nNOTE\n", sharedHelpNote),
    ]

    static func main() async {
        await runAsMain(commandNode)
    }
}
