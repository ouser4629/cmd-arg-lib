//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen
import Ex03_RunShared

public struct MacrosImplementation {
    @MainFunctionMacro
    public static func runM(
        _ comment: Comment?,
        command: Rest,
        v__verbose verbose: Flag,
        h__help help: MetaFlag = MetaFlag(helpElements: helpLayout)) throws
    {
        try readAndCall(comment, command: command.elements, verbose: verbose)
    }
}
