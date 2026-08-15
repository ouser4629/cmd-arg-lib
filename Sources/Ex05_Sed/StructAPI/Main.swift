//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import Ex05_SedShared

@main
struct Main: CommandNodeStruct {
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
