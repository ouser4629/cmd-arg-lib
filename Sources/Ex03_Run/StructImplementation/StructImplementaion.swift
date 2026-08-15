//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import CmdArgLibHelpScreen
import Ex03_RunShared

public struct StructImplementation: CommandNodeStruct {

    var comment: String?? = nil
    var command: Rest? = nil
    var verbose: Flag = false
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)

    public var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "run-s",
        embellishments: [
            .embellish("comment", label: "_", typeName: "Comment??"),
            .embellish("help", label: "h__help"),
            .embellish("verbose", label: "v__verbose"),
        ]
    )

    public func run(state: [Void]) throws -> [Void] {
        try readAndCall(comment ?? nil, command: command!.elements, verbose: verbose)
        return []
    }

    public init() {}
}
