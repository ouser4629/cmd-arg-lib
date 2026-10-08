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
import CmdArgLibProtocols
import CmdArgLibHelpScreen
import Ex03_RunShared

public struct RunS: MainFunctionDef{

    var comment: String?? = nil
    var command: Rest? = nil
    var verbose: Flag = false
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)

    public var attributes: MainFunctionAttributes? = MainFunctionAttributes(
        embellishments: [
            .embellish("comment", label: "_", typeName: "Comment??"),
            .embellish("help", label: "h__help"),
            .embellish("verbose", label: "v__verbose"),
        ]
    )

    public func run() throws {
        try readAndCall(comment ?? nil, command: command!.elements, verbose: verbose)
    }

    public init() {}
}
