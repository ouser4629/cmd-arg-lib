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

struct Quotes: CommandNodeDef {
    var h__help: MetaFlag = MetaFlag(helpElements: helpElements)

    var commandNodeAttributes: CommandNodeAttributes<TextStyle>? =  CommandNodeAttributes<TextStyle>(
        commandSynopsis: "Print quotes by famous people.",
        children: [generalNode, computingNode]
    )

    func run(state: [TextStyle]) throws -> [TextStyle]
    {
        return state
    }

    static let argumentAttributes = ArgumentAttributes()

    private static let generalNode = GeneralQuotes().commandNode
    private static let computingNode = ComputingQuotes().commandNode

    private static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\n", "Print quotes by famous people."),
        .synopsis("\nUSAGE\n", line: ["help", "$_:Subcommand"]),
        .text("\nOPTION"),
        .parameter("h__help", "Show help information"),
        .text("\nSUBCOMMANDS"),
        .commandContext(generalNode.context),
        .commandContext(computingNode.context),
    ]
}
