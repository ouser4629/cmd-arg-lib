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
import CmdArgLibHelpScreen

public let helpScreenMetaFlag = MetaFlag(helpElements: helpLayout)

public let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "A sed wrapper."),
    .synopsis("\nUSAGE\n", lines: [synopsisLine1Names, synopsisLine2Names]),
    .text("\nOPTIONS"),
    .parameter("n", quiet),
    .parameter("p", preview),
    .parameter("i", inplaceEdit, typeName: "Extension??"),
    .parameter("e", commands, typeName: "[Command]"),
    .parameter("f", commandRun, typeName: "[CommandFile]"),
    .parameter("_command", "", typeName: "Command??"),
    .parameter("_files", "", typeName: "Variadic<File>"),
    .parameter("generateManpage", "Generate a man page"),
    .parameter("version", "Show version information"),
    .parameter("h__help", "Show help information"),
    .text("\nNOTES\n", description01),
    .text("\n", description02),
    .text("\n", note1),
]

let synopsisLine1Names = ["n", "p", "i", "$_:Command", "_files"]
let synopsisLine2Names = ["n", "p", "i", "e", "f", "_files"]

let description01 = """
    The $F{-} utility reads each specified $E{_files}, or the standard input if no 
    $E{_files} is specified, modifying the input as specified by a list
    of editing commands. The input is then written to the standard output.
    """
let description02 = """
    A single command may be specified as the first argument to $F{-}, in which
    case no $S{e} or $S{f} options are allowed. Multiple commands
    may be specified by using the $S{e} or $S{f} options. All commands
    are applied to the input in the order they are specified regardless of their origin.
    """

let quiet = """
    By default, each line of input is echoed to the standard output after all of the
    commands have been applied to it. The $S{n} option suppresses this behavior
    """
let preview = """
    Print the generated sed command without executing it
    """
let inplaceEdit = """
    Edit each $E{_files} in-place, saving backups with the specified $E{i}.
    If a zero-length extension is given (""), no backup will be saved
    """
let commands = """
    Append $E{e} to the list of editing commands (may be repeated)
    """
let commandRun = """
    Append the editing commands found in the file $E{f} to the list of
    editing commands (may be repeated). The editing commands should each be listed
    on a separate line. The editing commands are read from the standard input if 
    $E{f} is “-”
    """

let note1 = """
    Regular expressions are always interpreted as extended (modern) regular expressions.
    """
