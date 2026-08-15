//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibCompletions
import CmdArgLibHelpScreen

public typealias Name = String
public enum Pet: String, CmdArgEnum { case dog, cat, bird }

public let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "Collect and print a person's personal information."),
    .synopsis("\nUSAGE\n", line: ["!generateCompletionScript"]),
    .text("\nOPTIONS"),
    .parameter("help", "Show help information."),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("count", countDescription),
    .text("\nPERSONAL INFORMATION"),
    .parameter("weight", "The person's weight in kgs"),
    .parameter("sonHas", "One or more of the pets owned by the person's son", .list(Pet.cases)),
    .parameter("daughterHas", "A pet owned by the person's daughter (can be repeated)", .list(Pet.cases)),
    .parameter("name", "The person's name"),
    .text("\nPETS"),
    .pseudoParameter("bird","A bird is colorful, intelligent, vibrant and highly social"),
    .pseudoParameter("cat","A cat is agile, curious and cuddly"),
    .pseudoParameter("dog", "A dog is man's best friend"),
    .text("\nNOTES\n", note)
]

private let countDescription = """
    Print the output n times where n is the absolute value of the $T{count} passed
    to $J{count}. If the $T{count} is negative the data is listed in reverse order.
    """

private let note = """
    The $J{u} and $J{l} flags shadow each other; the last 
    one encountered determines the formatting.
    
    There is a hidden meta-option, "$J{generateCompletionScript} $E{generateCompletionScript}",
    where $E{generateCompletionScript} can be \(ShellType.orCases("one of")). If specified,
    a corresponding completion script is printed to standard output.
    """

// * Import CmdArgLibHelpScreen to get `MetaFlag(helpElements:)`
//
// * Layout the help screen as a static array of `ShowElement`
//   * text - header and line-wrapped text
//   * synopsis - usage and synopsis lines in help screens and manual pages
//   * parameter - parameter description and completion hints
//   * rawValue - shows a pair, <name> <description> like a parameter
//
//  * Use [show macros](REFERENCE.md#show-macros) for string interpolation of
//    parameter names, labels, etc.

