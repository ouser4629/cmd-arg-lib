//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozillia.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCompletions

public let sharedHelp: [ShowElement] = [
    .text("DESCRIPTION\n", "Print quotes and recommended books."),
    .synopsis("\nUSAGE\n", line: ["$*", "$_:Subcommand", "!script"]),
    .text("\nMETA-OPTIONS"),
    .parameter("h__help", "Show help information"),
    .parameter("t__tree", "Show a hierarchical list of commands"),
    .parameter("v__version", "Show the version."),
    .text("\nOPTIONS"),
    .parameter("l__lower", "Lowercase the output"),
    .parameter("u__upper", "Uppercase the output"),
    .parameter("c__color","The color of the output (\(Color.orCases()))", .list(Color.cases)),
]

public let sharedHelpNote = """
    The $J{l__lower} and $J{u__upper} flags shadow each other; the last 
    one encountered determines the formatting.
    
    There is a hidden meta-option, "$J{generateCompletionScript} $E{generateCompletionScript}",
    where $E{generateCompletionScript} can be \(ShellType.orCases("one of")). If specified,
    a corresponding completion script is printed to standard output. The generated script includes
    all subcommands.
    """
