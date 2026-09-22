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

struct ComputingQuotes: CommandNodeFrame  {
    var count: Int = 1
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)

    var configuration: CommandNodeConfiguration<TextStyle>? =  CommandNodeConfiguration<TextStyle>(
        commandName: "computing",
        embellishments: [
            .embellish("help", label: "h__help"),
        ], 
        commandSynopsis: "Print quotes about computing.",
    )

    func run(state: [TextStyle]) throws -> [TextStyle]
    {
        if let TextStyle = state.first {
            try printCitedStringWith(TextStyle, count: count, stringAuthor: computingQuotes)
        }
        return []
    }

    static let helpLayout: [ShowElement] = [
        .text("DESCRIPTION\n", "Print quotes about computing."),
        .synopsis("\nUSAGE\n"),
        .text("\nOPTIONS"),
        .parameter("count", "The number of quotes to print"),
        .parameter("help","Show help information"),
    ]
}
