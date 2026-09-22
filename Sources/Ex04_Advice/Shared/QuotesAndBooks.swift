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

public typealias Count = Int
public typealias Author = String
public typealias Quote = String
public typealias Title = String

public let generalQuotes: [(String, Author)] = [
    ("Simplicity is complexity resolved.", "Constantin Brancusi"),
    ("Well done is better than well said.", "Benjamin Franklin"),
    ("Where all think alike, no one thinks very much.", "Walter Lippmann"),
    ("If a machine is expected to be infallible, it cannot also be intelligent.", "Alan Turing"),
]

public let computingQuotes: [(Quote, Author)] = [
    ("It is much more rewarding to do more with less.", "Donald Knuth"),
    ("Programming is a skill best acquired by practice and example rather than from books.", "Alan Turing"),
    ("All problems in computer science can be solved with another level of indirection.", "David Wheeler"),
    ("The only way to learn a new programming language is by writing programs in it.", "Kernighan and Ritchie"),
    ("The key to performance is elegance, not battalions of special cases.", "Jon Bentley and Doug McIlroy"),
    ("Easy things should be easy and hard things should be possible.", "Larry Wall"),
]

public let booksAndAuthor: [(Title, Author)] = [
    ("The Grapes of Wrath","John Steinbeck (1939)"),
    ("1984","George Orwell (1949)"),
    ("Animal Farm", "George Orwell (1945)"),
    ("To Kill a Mockingbird","Harper Lee (1960)"),
]

public func printCitedStringWith(
    _ textStyle: TextStyle,
    header: String = "Quote",
    count: Count,
    stringAuthor: [(String, Author)]) throws
{
    if count < 1 || count >     stringAuthor.count {
        throw Exception.error("Invalid count - must between 1 and \(    stringAuthor.count)")
    }
    let newQuotes = stringAuthor.shuffled()
    var lines = newQuotes[0..<count].map { "  \($0.0) - \($0.1)" }
    lines = ["\(header)\(lines.count > 1 ? "s" : "")"] + lines
    let format = textStyle.format(phrase:)
    let output = lines.map(format).joined(separator: "\n")
    throw Exception.stdout(output)
}
