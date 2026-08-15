//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import Ex05_SedShared

@main
struct Main {

    @MainFunctionMacro
    static func sedM(
        n quiet: Flag,
        p preview: Flag,
        i inplace: Extension?,
        e commands: Array<Command> = [],
        f commandFiles: [CommandFile] = [],
        _ command: Command?,
        _ files: Variadic<File> = [],
        generateManpage: MetaFlag = manpageMetaFlag,
        h__help help: MetaFlag = helpScreenMetaFlag,
        version: MetaFlag = MetaFlag(string: "Version 1.0")) throws
    {
        try work(
            quiet: quiet, preview: preview, inplaceEdit: inplace,
            commands: commands, commandFiles: commandFiles, command: command,
            files: files)
    }
}
