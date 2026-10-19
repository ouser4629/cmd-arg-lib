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

import CmdArgParser
import CmdArgCompletions
import Ex02_PersonShared

@main
struct PersonS: MainFunctionDef {
    var h__help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var c__count: Int = 1
    var w__weight: Double?? = nil
    var s__sonHas: Some<Pet> = []
    var d__daughterHas: [Pet] = []
    var _name: Name? = nil
    var generateCompletionScript: MetaOption<Shell> = MetaOption(generator)

    // Configuration
    static let argumentAttributes = CommandArgumentAttributes(
        shadowGroups: ["u l"],
    )

    @MainActor
    func run() {
        showPerson(l: l, u: u, count: c__count, weight: w__weight, sonHas: s__sonHas.elements, daughterHas: d__daughterHas, name: _name)
    }

    static let generator = Shell(name: "person-s", suggestionElements: helpLayout)
}

// * Purpose
//   * Shows use of every `CmdArgTBasicType` provided "out of the box"
//   * Shows use of Array<B>, Some<B> and Optional<B> where B is a basic type
//   * Shows use of default values
//   * Shows use of typeName embellishing to customize placeholders in help screends, etc.
//   * Shows use of the help screen meta-flag initializer: `MetaFlag(helpElements:)`
//   * Shows use of the script generation type: `MetaOption<CompletionGenerator>`
