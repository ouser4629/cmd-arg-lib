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
import CmdArgLibTestSupport
import Foundation
import Testing
import Ex03_RunStructImplementation

func makeFilesNamed(_ files: String...) -> Bool  {
    let fm = FileManager.default
    var ok = true
    for file in files {
        if !fm.createFile(atPath: file, contents: "<\(file) content>".data(using: .utf8)) {
            ok = false
        }
    }
    return ok
}

@Suite(.serialized)
struct Ex03_RunStructImplementaionTests {

    @Test func sJustCommand() async throws {
        try await withinTemporaryDirectory{
            if !makeFilesNamed("foo", "baz") { fatalError() }
            let input = #"--command ls -1"#
            let expected = """
            baz
            foo
            """
            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    @Test func sVerbose() async throws {
        try await withinTemporaryDirectory {
            if !makeFilesNamed("foo", "baz") { fatalError() }
            let input = #"-v --command cat foo baz foo"#
            let expected = """
            cat foo baz foo
            ---
            <foo content><baz content><foo content>
            """
            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    @Test func sVerboseWithComment() async throws {
        try await withinTemporaryDirectory{
            if !makeFilesNamed("foo", "baz") { fatalError() }
            let input = #"-v "Do the following command:" --command cat foo baz"#
            let expected = """
            Do the following command:
            cat foo baz
            ---
            <foo content><baz content>
            """
            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
            #expect(ok)
        }
    }

    // Annotated command function throws Exception.stderr
    @Test func sBadCommandName() async throws {
            let input = #"--command badName baz"#
            let expected = """
            Unknown command: badName
            """
            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
            #expect(ok)
    }

    // Annotated command function throws Exception.error
    @Test func sBadComment() async throws {
            let input = #""We all work in a zoo"  --command cat baz"#
            let expected = """
            Error:
              The comment is too long.
            See "run-s --help" for more information.
            """
            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
            #expect(ok)
    }

    // Annotated command function lets io error paas uncaught
    @Test func sUncaughtError() async throws {
        try await withinTemporaryDirectory{
            if !makeFilesNamed("foo", "baz") { fatalError() }
            let input = #"--command cat nonExistingFile"#
            let expected = """
            cat: nonExistingFile: No such file or directory
            """
            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
            #expect(ok)
        }
    }

//    // This test intentially fails. It is an example used in the cmd-arg-lib docs
//    @Test func sDefectiveTest() async throws {
//        try await withinTemporaryDirectory {
//            if !makeFilesNamed("xcode", "zed") { fatalError() }
//            let input = #"-v 'Actual comment' --command ls -1"#
//            let expected = """
//            Expected comment
//            ls -1
//            ---
//            vscode
//            """
//            let ok = await testOutput(of: StructImplementation.commandNode.run, with: input, expecting: expected)
//            #expect(ok)
//        }
//    }
}
