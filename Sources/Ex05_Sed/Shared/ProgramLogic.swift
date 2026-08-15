//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import Foundation

public typealias Extension = String
public typealias File = RawArg
public typealias Command = RawArg
public typealias CommandFile = RawArg

public func work(
    quiet: Flag = false,
    preview: Flag = false,
    inplaceEdit: Extension? = nil,
    commands: [Command] = [],
    commandFiles: [CommandFile] = [],
    command: Command? = nil,
    files: Variadic<File> = []) throws
{
    var commandTokens: [RawArg] = []
    var fileTokens: [RawArg] = []
    if commands.isEmpty && commandFiles.isEmpty {
        // This is first synopsis treat command as a command
        if let command {
            commandTokens = [command]
            fileTokens = files
        }
    } else {
        // This is sceond synopsis, treat command as a file name
        commandTokens = commands + commandFiles
        if let command {
            fileTokens.insert(command, at: 0)
        }
        fileTokens += files
    }
    if commandTokens.isEmpty {
        return
    }

    var args = ["-E"]
    if quiet { args.append("-n") }
    if let ext = inplaceEdit {
        args.append("-i")
        args.append(ext.isEmpty ? "\"\"" : ext)
    }
    commandTokens.sort(by: RawArg.before)
    for token in commandTokens {
        if token.parameterName == "commandFiles" {
            args.append("-f")
            args.append(token.value)

        } else {
            args.append("-e")
            args.append(token.value)
        }
    }

    args += fileTokens.map { $0.value }
    if preview {
        print("sed \(args.joined(separator: " "))")
    } else {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/sed")
        process.arguments = args
        try process.run()
        process.waitUntilExit()
    }
}
