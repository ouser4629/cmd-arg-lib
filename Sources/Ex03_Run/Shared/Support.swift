//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen
import Foundation

public typealias Comment = String

let tools = ["echo", "ls", "cat"]

public let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "Print a comment, if specified, and run a command."),
    .synopsis("\nUSAGE\n"),
    .text("\nPARAMETERS"),
    .parameter("comment", "A comment, must be less than 5 words"),
    .parameter("command", "The name and arguments of a command to run."),
    .parameter("verbose", "Print the comment, if any, and the command before running."),
    .parameter("help", "Show help information."),
    .text("\nNOTES\n", notes),
]

private let notes = """
    The allowed commands are \(tools.joinedWith("and", quoteChar: "\"")).
    """

public func readAndCall(_ comment: String?, command: [String], verbose: Bool) throws {
    var output: [String] = []
    guard comment?.components(separatedBy: .whitespaces).count ?? 0 < 5 else {
        throw Exception.error("The comment is too long.")
    }
    if verbose {
        if let comment {
            output.append(comment)
        }
        output.append(command.joined(separator: " "))
        output.append("---")
    }
    if let toolName = command.first {
        if !tools.contains(toolName)  {
            throw Exception.stderr("Unknown command: \(toolName)")
        }
        let args = Array(command.dropFirst(1))
        let process = Process()
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        process.executableURL = URL(fileURLWithPath: "/bin/\(toolName)")
        process.arguments = args
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let string = String(data: data, encoding: .utf8) {
            output.append(string.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
    throw Exception.stdout(output.joined(separator: "\n"))
}

