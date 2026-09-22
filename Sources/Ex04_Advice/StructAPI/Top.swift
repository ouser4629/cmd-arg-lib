// Copyright (c) 2025-2026 Peter Summerland LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import CmdArgLibCore
import CmdArgLibCommandNodeFrame
import CmdArgLibCompletions
import CmdArgLibHelpScreen
import Foundation
import Ex04_AdviceShared

@main
struct Top: CommandNodeFrame  {
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var tree: MetaFlag = MetaFlag(treeFor: "advice-s", synopsis: "")
    var version: MetaFlag =  MetaFlag(string: "0.1.0")
    var script: MetaOption<CompletionGenerator> = MetaOption(generator)
    var upper: Flag = false
    var lower: Flag = false
    var color: Color = .white

    var configuration: CommandNodeConfiguration<TextStyle>? = CommandNodeConfiguration<TextStyle>(
        commandName: "advice-s",
        shadowGroups: ["lower upper"],
        embellishments: [
            .embellish("help", label: "h__help"),
            .embellish("script", label: "generateCompletionScript", typeName: "MetaOption<Shell>"),
            .embellish("tree", label: "t__tree"),
            .embellish("version", label: "v__version"),
            .embellish("lower", label: "l__label"),
            .embellish("upper", label: "u__upper"),
            .embellish("color", label: "c__color"),
        ],
        commandSynopsis: "Print quotes and book titles.",
        children: [booksNode, quotesNode]
    )

    func run(state: [TextStyle]) -> [TextStyle]
    {
        let textStyle = TextStyle(upper: upper, lower: lower, color: color)
        return [textStyle]
    }

    static let generator = CompletionGenerator(name: "advice-s", suggestionElements: helpLayout)

    private static let booksNode = Books.commandNode

    private static let quotesNode = Quotes.commandNode

    private static let children = [Quotes.commandNode, Books.commandNode,]

    private static let childNodes = [Quotes.commandNode, Books.commandNode,]

    private static let helpLayout = sharedHelp + [
        .text("SUBCOMMANDS"),
        .commandContext(quotesNode.context),
        .commandContext(booksNode.context),
        .text("\nNOTE\n", sharedHelpNote),
    ]
}
