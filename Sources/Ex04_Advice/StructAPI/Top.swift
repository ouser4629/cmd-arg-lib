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
import CmdArgLibCompletions
import CmdArgLibHelpScreen
import Foundation
import Ex04_AdviceShared

@main
struct AdviceS: CommandNodeDef  {
    var h__help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var t__tree: MetaFlag = MetaFlag(treeFor: "advice-s", synopsis: "")
    var v__version: MetaFlag =  MetaFlag(string: "0.1.0")
    var generateCompletionScript: MetaOption<CompletionGenerator> = MetaOption(generator)
    var u__upper: Flag = false
    var l__lower: Flag = false
    var c__color: Color = .white

    var commandNodeAttributes: CommandNodeAttributes<TextStyle>? = CommandNodeAttributes<TextStyle>(
        commandSynopsis: "Print quotes and book titles.",
        children: children
    )

    func run(state: [TextStyle]) -> [TextStyle]
    {
        let textStyle = TextStyle(upper: u__upper, lower: l__lower, color: c__color)
        return [textStyle]
    }

    static let generator = CompletionGenerator(name: "advice-s", suggestionElements: helpLayout)

    static let argumentAttributes = ArgumentAttributes(
        shadowGroups: ["u__upper l__lower"],
        showElements: helpLayout
    )

    private static let booksNode = Books().commandNode
    private static let quotesNode = Quotes().commandNode
    private static let children = [quotesNode, booksNode,]

    private static let helpLayout = sharedHelp + [
        .text("SUBCOMMANDS"),
        .commandContext(quotesNode.context),
        .commandContext(booksNode.context),
        .text("\nNOTE\n", sharedHelpNote),
    ]

    static func main() async {
        await runAsMain(Self().commandNode)
    }
}
