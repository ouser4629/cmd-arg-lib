//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

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
