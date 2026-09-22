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
