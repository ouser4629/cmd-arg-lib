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
import Foundation

public enum Color: String, CmdArgEnum {
    case red, yellow, white
}

public struct TextStyle: Sendable {
    private let upper: Bool
    private let lower: Bool
    public let color: Color

    public init(upper: Bool, lower: Bool, color: Color) {
        self.upper = upper
        self.lower = lower
        self.color = color
    }

    public func format(words: [String]) -> [String] {
        let formatted =
        if upper {
            words.map { $0.uppercased() }
        } else if lower {
            words.map { $0.lowercased() }
        } else {
            words
        }
        var startCode = 97
        let endCode = 0
        switch color {
        case .red: startCode = 31
        case .yellow: startCode = 33
        case .white: startCode = 97
        }
        return formatted.map{"\u{001B}[\(startCode)m\($0)\u{001B}[\(endCode)m"}
    }

    public func format(phrase: String) -> String {
        format(words: phrase.components(separatedBy: .whitespaces)).joined(separator: " ")
    }
}
