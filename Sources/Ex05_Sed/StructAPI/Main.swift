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

import CmdArgParser
import Ex05_SedShared

@main
struct SedS: MainFunctionDef {
    var n: Flag = false
    var p: Flag = false
    var i: Extension?? = nil
    var e: [Command] = []
    var f: [CommandFile] = []
    var _command: Command?? = nil
    var _files: Some<File> = []
    var h__help: MetaFlag = helpScreenMetaFlag
    var generateManpage: MetaFlag = manpageMetaFlag
    var version: MetaFlag = MetaFlag(string: "Version 1.0")

    func run() throws {
        try work(
            quiet: n,
            preview: p,
            inplaceEdit: i ?? nil,
            commands: e,
            commandFiles: f,
            command: _command ?? nil,
            files: _files
        )
    }
}
