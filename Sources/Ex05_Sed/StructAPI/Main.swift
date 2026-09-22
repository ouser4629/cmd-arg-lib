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
import Ex05_SedShared

@main
struct Main: CommandNodeFrame {
    var quiet: Flag = false
    var preview: Flag = false
    var inplace: Extension?? = nil
    var commands: [Command] = []
    var commandFiles: [CommandFile] = []
    var command: Command?? = nil
    var files: Variadic<File> = []
    var help: MetaFlag = helpScreenMetaFlag
    var generateManpage: MetaFlag = manpageMetaFlag
    var version: MetaFlag = MetaFlag(string: "Version 1.0")

    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "sed-s",
        embellishments: [
            .embellish("help",label: "h__help"),
            .embellish("quiet",label: "n",typeName: "Flag"),
            .embellish("preview",label: "p",typeName: "Flag"),
            .embellish("inplace", label: "i", typeName: "Extension??"),
            .embellish("commands", label: "e", typeName: "[Command]"),
            .embellish("commandFiles", label: "f",typeName: "[CommandFile]"),
            .embellish("command",label: "_",typeName: "Command??"),
            .embellish("files",label: "_",typeName: "Variadic<File>"),
        ]
    )

    func run(state: [Void]) throws -> [Void] {
        try work(
            quiet: quiet,
            preview: preview,
            inplaceEdit: inplace ?? nil,
            commands: commands,
            commandFiles: commandFiles,
            command: command ?? nil,
            files: files
        )
        return []
    }
}
