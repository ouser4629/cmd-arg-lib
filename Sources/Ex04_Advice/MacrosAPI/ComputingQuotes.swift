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
