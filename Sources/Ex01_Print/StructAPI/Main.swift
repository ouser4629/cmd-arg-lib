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

