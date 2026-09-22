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
