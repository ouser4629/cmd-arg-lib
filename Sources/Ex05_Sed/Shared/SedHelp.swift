//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen

public let helpScreenMetaFlag = MetaFlag(helpElements: helpLayout)

private let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "A sed wrapper."),
    .synopsis("\nUSAGE\n", lines: [synopsisLine1Names, synopsisLine2Names]),
    .text("\nOPTIONS"),
    .parameter("quiet", quiet),
    .parameter("preview", preview),
    .parameter("inplace", inplaceEdit),
    .parameter("commands", commands),
    .parameter("commandFiles", commandRun),
    .parameter("generateManpage", "Generate a man page"),
    .parameter("version", "Show version information"),
    .parameter("help", "Show help information"),
    .text("\nNOTES\n", description01),
    .text("\n", description02),
    .text("\n", note1),
]

let synopsisLine1Names = ["quiet", "preview", "inplace", "$_:Command", "files"]
let synopsisLine2Names = ["quiet", "preview", "inplace", "commands", "commandFiles", "files"]

let description01 = """
    The $F{-} utility reads each specified $E{files}, or the standard input if no 
    $E{files} is specified, modifying the input as specified by a list
    of editing commands. The input is then written to the standard output.
    """
let description02 = """
    A single command may be specified as the first argument to $F{-}, in which
    case no $S{commands} or $S{commandFiles} options are allowed. Multiple commands
    may be specified by using the $S{commands} or $S{commandFiles} options. All commands
    are applied to the input in the order they are specified regardless of their origin.
    """

let quiet = """
    By default, each line of input is echoed to the standard output after all of the
    commands have been applied to it. The $S{quiet} option suppresses this behavior
    """
let preview = """
    Print the generated sed command without executing it
    """
let inplaceEdit = """
    Edit each $E{files} in-place, saving backups with the specified $E{inplace}.
    If a zero-length extension is given (""), no backup will be saved
    """
let commands = """
    Append $E{commands} to the list of editing commands (may be repeated)
    """
let commandRun = """
    Append the editing commands found in the file $E{commandFiles} to the list of
    editing commands (may be repeated). The editing commands should each be listed
    on a separate line. The editing commands are read from the standard input if 
    $E{commandFiles} is “-”
    """

let note1 = """
    Regular expressions are always interpreted as extended (modern) regular expressions.
    """
