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
import CmdArgLibCompletions
import CmdArgLibHelpScreen

public typealias Name = String
public enum Pet: String, CmdArgEnum { case dog, cat, bird }

public let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "Collect and print a person's personal information."),
    .synopsis("\nUSAGE\n", line: ["!generateCompletionScript"]),
    .text("\nOPTIONS"),
    .parameter("h__help", "Show help information."),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("c__count", countDescription),
    .text("\nPERSONAL INFORMATION"),
    .parameter("w__weight", "The person's weight in kgs"),
    .parameter("s__sonHas", "One or more of the pets owned by the person's son", .list(Pet.cases)),
    .parameter("d__daughterHas", "A pet owned by the person's daughter (can be repeated)", .list(Pet.cases)),
    .parameter("_name", "The person's name"),
    .text("\nPETS"),
    .pseudoParameter("bird","A bird is colorful, intelligent, vibrant and highly social"),
    .pseudoParameter("cat","A cat is agile, curious and cuddly"),
    .pseudoParameter("dog", "A dog is man's best friend"),
    .text("\nNOTES\n", note)
]

private let countDescription = """
    Print the output n times where n is the absolute value of the $T{c__count} passed
    to $J{c__count}. If the $T{c__count} is negative the data is listed in reverse order.
    """

private let note = """
    The $J{u} and $J{l} flags shadow each other; the last 
    one encountered determines the formatting.
    
    There is a hidden meta-option, "$J{generateCompletionScript} $E{generateCompletionScript}",
    where $E{generateCompletionScript} can be \(ShellType.orCases("one of")). If specified,
    a corresponding completion script is printed to standard output.
    """

public func showPerson(l: Flag, u: Flag, count: Int, weight: Double??, sonHas: [Pet], daughterHas: [Pet] = [], name: Name?)
{
    var lines: [String] = []
    if let weight, let weight { lines.append("  \(name!) weighs \(weight) kgs.") }
    if !sonHas.isEmpty  { lines.append("  \(name!)'s son has \(sonHas.map{"a \($0)"}.joinedWith("and")).") }
    if !daughterHas.isEmpty  { lines.append("  \(name!)'s daughter has \(daughterHas.map{"a \($0)"}.joinedWith("and")).") }
    if lines.isEmpty  { lines.append("  No data was found for \(name!).") }
    if count < 0 { lines.reverse() }
    lines.insert("DATA:", at: 0)
    var line = lines.joined(separator: "\n")
    line = u ? line.uppercased() : l ? line.lowercased() : line
    for _ in 0..<abs(count) { print(line) }
}


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

