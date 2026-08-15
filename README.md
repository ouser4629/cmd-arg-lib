<!-- 
//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.
-->

## Command Argument Library

A Swift library for defining, parsing, and documenting command-line interfaces.

* Use the library's macro based API to convert ordinary Swift functions into terminal commands with one line of code:

```swift
@main
struct Main {
    @MainFunctionMacro
    static public func printM (
        u: Flag, 
        l: Flag, 
        count: Int = 1, 
        phrase: String)
    { ... }
}
```

* Alternatively, use its struct-based API:

```swift
@main
struct Main: CommandNodeStruct {
    var u: Flag = false
    var l: Flag = false
    var count: Int = 1
    var phrase: String? = nil
    
    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "person-s",
    )
    
    func run(state: [Void]) throws -> [Void] 
    { ... }
```

* Compose help screens with show element constructors:

```swift
private static let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "Print a phrase multiple times."),
    .synopsis("\nUSAGE\n"),
    .text("\nPARAMETERS"),
    .parameter("count", "The number of times to print the phrase"),
    .parameter("phrase", "The phrase to print"),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("help", "Show help information"),
]
```

CLIs defined using CAL mimic Swift, yet feel natural to shell users.

Help screens and manual pages are built from composable show elements, rather than from fixed templates.

Together, these features allow CAL to produce CLIs that feel native to Swift while meeting the documentation and usability expectations of professional command-line tools.

---

## Examples

This repository includes five examples designed to demonstrate almost all of CAL's features.

Each example is implemented twice, first with CAL's macro-based API, and then with its struct-based API.

<details>
<summary>Installation</summary>

It is recommended to install [`caltool`](https://github.com/ouser4629/cmd-arg-lib-tool.git), CAL's command-line development and installation tool.

```
> rm -rf Demo && mkdir Demo && cd Demo

Demo> git clone https://github.com/ouser4629/cmd-arg-lib.git
...

Demo> cd cmd-arg-lib

cmd-arg-lib> swift build -c release
...

cmd-arg-lib> caltool install --with-completion-scripts fish zsh
advice-m
    installed "advice-m" in /Users/po/.local/bin
    installed "advice-m.fish" in /Users/po/.config/fish/completions
    installed "_advice-m" in /Users/po/.config/zsh/completions
advice-s
    installed "advice-s" in /Users/po/.local/bin
    installed "advice-s.fish" in /Users/po/.config/fish/completions
    installed "_advice-s" in /Users/po/.config/zsh/completions
person-m
    installed "person-m" in /Users/po/.local/bin
    installed "person-m.fish" in /Users/po/.config/fish/completions
    installed "_person-m" in /Users/po/.config/zsh/completions
person-s
    installed "person-s" in /Users/po/.local/bin
    installed "person-s.fish" in /Users/po/.config/fish/completions
    installed "_person-s" in /Users/po/.config/zsh/completions
print-m1
    installed "print-m1" in /Users/po/.local/bin
print-s1
    installed "print-s1" in /Users/po/.local/bin
run-m
    installed "run-m" in /Users/po/.local/bin
run-s
    installed "run-s" in /Users/po/.local/bin
sed-m
    installed "sed-m" in /Users/po/.local/bin
    installed "sed-m.1" in /Users/po/.local/share/man/man1
sed-s
    installed "sed-s" in /Users/po/.local/bin
    installed "sed-s.1" in /Users/po/.local/share/man/man1
...

cmd-arg-lib> caltool uninstall
advice-m
    uninstalled "advice-m" in /Users/po/.local/bin
    uninstalled "advice-m.fish" in /Users/po/.config/fish/completions
    uninstalled "_advice-m" in /Users/po/.config/zsh/completions
advice-s
    uninstalled "advice-s" in /Users/po/.local/bin
    uninstalled "advice-s.fish" in /Users/po/.config/fish/completions
    uninstalled "_advice-s" in /Users/po/.config/zsh/completions
person-m
    uninstalled "person-m" in /Users/po/.local/bin
    uninstalled "person-m.fish" in /Users/po/.config/fish/completions
    uninstalled "_person-m" in /Users/po/.config/zsh/completions
person-s
    uninstalled "person-s" in /Users/po/.local/bin
    uninstalled "person-s.fish" in /Users/po/.config/fish/completions
    uninstalled "_person-s" in /Users/po/.config/zsh/completions
print-m1
    uninstalled "print-m1" in /Users/po/.local/bin
print-s1
    uninstalled "print-s1" in /Users/po/.local/bin
run-m
    uninstalled "run-m" in /Users/po/.local/bin
run-s
    uninstalled "run-s" in /Users/po/.local/bin
sed-m
    uninstalled "sed-m" in /Users/po/.local/bin
    uninstalled "sed-m.1" in /Users/po/.local/share/man/man1
sed-s
    uninstalled "sed-s" in /Users/po/.local/bin
    uninstalled "sed-s.1" in /Users/po/.local/share/man/man1
```

</details>
 
---

### 1 - Print

This example prints a phrase.

It demonstrates basic usage.

<details>
<summary>Help Screen</summary>

```
> print-m -h
DESCRIPTION
  Print a phrase multiple times.

USAGE
  print-m [-hlu] [--count <int>] <phrase>

PARAMETERS
  -h/--help             Show help information.
  -l                    Lowercase the output.
  -u                    Uppercase the output.
  --count <int>         The number of times to print the phrase (default: 1).
  <phrase>              The phrase to print.

NOTE
  The -l and -u flags shadow each other. The last one specified takes precedence.
```

</details>

<details>
<summary>Command Calls</summary>

```
> print-m --count 2 "Hello world!"
Hello world!
Hello world!

> print-m -lu "Hello world!"
HELLO WORLD!

> print-m -ul "Hello world!"
hello world!

> print-m -xuxxylzz --count 2.1
Errors:
  unrecognized options: "-x", "-y" and "-z", in "-xuxxylzz"
  missing value: "<phrase>"
  "2.1" is not a valid <int> after --count
See "print-m --help" for more information.
```

</details>

<details>
<summary>Macro-Based Implementation</summary>

```swift
import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen

@main
struct Main {
    typealias Phrase = String

    @MainFunctionMacro(shadowGroups: ["u l"])
    static public func printM(
        h__help help: MetaFlag = MetaFlag(helpElements: helpLayout),
        l: Flag,
        u: Flag,
        count: Int = 1,
        _ phrase: Phrase) throws
    {
        guard count >= 1 else { throw Exception.error("count must be >= 1") }
        let line = u ? phrase.uppercased() : l ? phrase.lowercased() : phrase
        for _ in 1...count { print(line) }
    }

    private static let helpLayout: [ShowElement] = [ ... ]
}
```

`Flag` is a `typealias` for `Bool` with an implied value of `false`. Parameters with default values are optional in the CLI. Others are required.”

</details>

<details>
<summary>Struct-Based Implementation</summary>

```swift
import CmdArgLibCore
import CmdArgLibCommandNodeStruct
import CmdArgLibHelpScreen

@main
struct Main: CommandNodeStruct {
    typealias Phrase = String
    
    var help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var count: Int = 1
    var phrase: Phrase? = nil

    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "print-s1",
        shadowGroups: ["u l"],
        embellishments: [
            .embellish("help", label: "h__help"),
            .embellish("phrase", label: "_", typeName: "Phrase?"),
        ]
    )

    func run(state: [Void]) throws -> [Void] {
        guard count >= 1 else { throw Exception.error("count must be >= 1") }
        let line = u ? phrase!.uppercased() : l ? phrase!.lowercased() : phrase!
        for _ in 1...count { print(line) }
        return []
    }

    private static let helpLayout: [ShowElement] = [ ... ]
}
```

Embellishments are required because stored properties don't have labels and, at run time, type aliases are
removed.

All stored properties must have a default value. Stored properties with `nil` default values like `phrase`, are required 
arguments in the CLI. Others are not required.

</details>

<details>
<summary>Help Screen Layout</summary>

```swift
private static let helpLayout: [ShowElement] = [
    .text("DESCRIPTION\n", "Print a $D{phrase} multiple times."),
    .synopsis("\nUSAGE\n"),
    .text("\nPARAMETERS"),
    .parameter("help", "Show help information"),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("count", "The number of times to print the $D{phrase}"),
    .parameter("phrase", "The $D{phrase} to print"),
    .text("\nNOTE\n", "The $S{l} and $S{u} flags shadow each other. The last one specified takes precedence."),
]
```

`$S` and `$D` are show macros. E.g., `$S` inserts the formatted shortest label for the parameter named
between the brackets. `$D` inserts its unformatted type name, including any type alias or embellishment.”

</details>

---

### 2 - Person

This example collects and prints a person's personal data.

It demonstrates nearly every feature needed to build a typical non-hierarchical command tool.

<details>
<summary>Help Screen</summary>

```
> person-m -h
DESCRIPTION
  Collect and print a person's personal information.

USAGE
  person-m [-hlu] [-c <int>] [-w <double>] [-s <pet>...] [-d <pet>] <name>

OPTIONS
  -h/--help                Show help information.
  -l                       Lowercase the output.
  -u                       Uppercase the output.
  -c/--count <int>         Print the output n times where n is the absolute value of
                           the <int> passed to -c/--count. If the <int> is negative
                           the data is listed in reverse order. (default: 1).

PERSONAL INFORMATION
  -w/--weight <double>     The person's weight in kgs.
  -s/--son-has <pet>...    One or more of the pets owned by the person's son.
  -d/--daughter-has <pet>  A pet owned by the person's daughter (can be repeated).
  <name>                   The person's name.

PETS
  bird                     A bird is colorful, intelligent, vibrant and highly
                           social.
  cat                      A cat is agile, curious and cuddly.
  dog                      A dog is man's best friend.

NOTES
  The -u and -l flags shadow each other; the last one encountered determines the
  formatting.

  There is a hidden meta-option, "--generate-completion-script <shell>", where
  <shell> can be one of "zsh" or "fish". If specified, a corresponding completion
  script is printed to standard output.
```

</details>

<details>
<summary>Command Calls</summary>

```
> person-m Mary -lu --weight 55 --son-has bird dog cat -d bird -d cat
DATA:
  MARY WEIGHS 55.0 KGS.
  MARY'S SON HAS A BIRD, A DOG AND A CAT.
  MARY'S DAUGHTER HAS A BIRD AND A CAT.
```

```
> person-m Mary -ulc -1 --weight 55 --son-has bird dog cat -d bird -d cat
data:
  mary's daughter has a bird and a cat.
  mary's son has a bird, a dog and a cat.
  mary weighs 55.0 kgs.
```

```
> person-m -uxyxdfrog --count=2.1 -s ant bee --daughter-has eel -s cat --weig
Errors:
  unrecognized options: "-x" and "-y", in "-uxyxdfrog"
  unrecognized option: "--weig"
  duplicate occurrences of the "-s" option
  missing value: "<name>"
  "2.1" is not a valid <int> after --count
  "frog" is not a valid <pet> after -d
  "eel" is not a valid <pet> after --daughter-has
See "person-m --help" for more information.
```

</details>

---

### 3 - Run

This example optionally prints a comment before running a command using `Process`.

It demonstrates

* using [Exception](REFERENCE.md#exception) to write to CAL's error screen, standard output
  and standard error in [exception pure](REFERENCE.md#exception-pure) functions
* using a CLI parameter of type [`Rest`](REFERENCE.md#rest) to collect all subsequent words verbatim
* using CAL's [CmdArgLibTestSupport](https://github.com/ouser4629/CmdArgLibTestSupport.git) module to test 
  expected command output

<details>
<summary>Help Screen</summary>

```
> run-m --help
DESCRIPTION
  Print a comment, if specified, and run a command.

USAGE
  run-m [-vh] [<comment>] --command <string>...

PARAMETERS
  <comment>              A comment, must be less than 5 words.
  --command <string>...  The name and arguments of a command to run.
  -v/--verbose           Print the comment, if any, and the command before running.
  -h/--help              Show help information.

NOTES
  The allowed commands are "print", "ls" and "cat".
```

</details>

<details>
<summary>Using Exception and Rest</summary>

```
# Set up
> print "<foo content>" > foo && print "<baz content>" > baz
```

In the following, "worker" is the method that performs program logic.

```
# Syntax errors that worker never sees
> run-m -v 'This is a silly long comment' ls -1
Errors:
  missing an occurence of the "--command" option
  unassigned arguments: ls and -1
See "run-m --help" for more information.
```

```
# Worker throws `Exception.error(_:)` to write to the error screen
> run-m -v 'This is a silly long comment' --command ls -1
Error:
  The comment is too long.
See "run-m --help" for more information.
```

```
# Worker throws `Exception.stdout(_:)` to write to standard output
> run-m -v 'List directory content' --command ls -1
Actual comment
ls -1
---
baz
foo
```

```
# Worker throws `Exception.stdout(_:)` to write to standard output
> run-m --command print Nothing gets by Rest , including --help , -- and -h
Nothing gets by Rest , including --help , -- and -h
```

```
# Worker throws `Exception.stderr(_:)` to write to standard error
> run-m --command foo
Unknown command: foo
```

```
# Worker ignores system i/o error, CAL handles it
> run-m --command cat bar
cat: bar: No such file or directory
```

</details>

<details>
<summary>Using Test Support</summary>

This test is commented out because it is designed to fail.”

```swift
@Test func defectiveTest() throws {
    try withinTemporaryDirectory {
        if !makeFilesNamed("xcode", "zed") { fatalError() }
        let input = #"-v 'Actual comment' --command ls -1"#
        let expected = """
            Expected comment
            ls -1
            ---
            vscode
            """
        let ok = testOutput(of: MacrosImplementation.run, with: input, expecting: expected)
        #expect(ok)
    }
}
```

The test sets up a temporary directory with two text files, "xcode" and "zed". The `testOutput` function 
will run the example with the indicated input, the same as if run from the terminal. I.e.,

```
> touch xcode zed

> run-m -v 'Actual comment' --command ls -1
Actual comment
ls -1
---
xcode
zed 
```

But the test expects 'run-m' to produce this:

```
> run-m -v 'Actual comment' --command ls -1
Expected comment
ls -1
---
vscode
zed 
```

If the defective test is uncommented, `swift test` will report the error
in diff format:

```
> swift test
Building for debugging...
...
◇ Test defectiveTest() started.
------ OUTPUT MISMATCH at Ex03_RunMacrosTests/Ex03_MacrosTests.swift:122 
+ Actual comment
- Expected comment
  ls -1
  ---
+ xcode
+ zed
- vscode
------ END MISMATCH --- "+" and "-" indicate changes to expected to match actual
✘ Test defectiveTest() recorded an issue at Ex03_MacrosTests.swift:123:13: Expectation failed: ok
✘ Test defectiveTest() failed after 0.100 seconds with 1 issue.
```

See [CmdArgLibTestSuite](https://github.com/ouser4629/CmdArgLibTestSuite.git) for numerous examples.

</details>

---

### 4 - Advice

This example displays quotes and recommends books. 

It demonstrates a hierarchical command structure in which state is passed from parent commands to child commands.

<details>
<summary>Help Screen</summary>

```
> advice-m -h
DESCRIPTION
  Print quotes and recommended books.

USAGE
  advice-m [-htvlu] [-c <color>] <subcommand>

META-OPTIONS
  -h/--help             Show help information.
  -t/--tree             Show a hierarchical list of commands.
  -v/--version          Show the version.

OPTIONS
  -l/--lower            Lowercase the output.
  -u/--upper            Uppercase the output.
  -c/--color <color>    The color of the output ("red", "yellow" or "white")
                        (default: "white").
SUBCOMMANDS
  quotes    Print quotes by famous people.
  books     Print a list of recommended books.

NOTE
  The -l/--lower and -u/--upper flags shadow each other; the last one encountered
  determines the formatting.

  There is a hidden meta-option, "--generate-completion-script <shell>", where
  <shell> can be one of "zsh" or "fish". If specified, a corresponding completion
  script is printed to standard output. The generated script includes all
  subcommands.
```
</details>

<details>
<summary>Tree</summary>

```
> advice-m -t
advice-m
├── quotes
│   ├── general - print quotes about life in general
│   └── computing - print quotes about computing
└── books - print a list of recommended books
```

</details>

<details>
<summary>Command Calls</summary>

```
> advice-m --upper quotes general --count 2
QUOTES
  WELL DONE IS BETTER THAN WELL SAID. - BENJAMIN FRANKLIN
  SIMPLICITY IS COMPLEXITY RESOLVED. - CONSTANTIN BRANCUSI

> advice-m --upper -c green quotes general --count 2.0
Error:
  "green" is not a valid <color> after -c
See "advice-m --help" for more information.

> advice-m --upper quotes general --count 2.0
Error:
  "2.0" is not a valid <count> after --count
See "advice-m quotes general --help" for more information.
```

</details>

---

### 5 - Sed Wrapper

This example wraps sed.

It shows more advanced usage, including
the library's [CmdArgLibManpage](https://github.com/ouser4629/CmdArgLibManpage.git) module.

<details>
<summary>Help Screen</summary>

```
DESCRIPTION
  A sed wrapper.

USAGE
  sed-m [-np] [-i <extension>] <command> [<file>...]
  sed-m [-np] [-i <extension>] [-e <command>] [-f <command-file>] [<file>...]

OPTIONS
  -n                    By default, each line of input is echoed to the standard
                        output after all of the commands have been applied to it. The
                        -n option suppresses this behavior.
  -p                    Print the generated sed command without executing it.
  -i <extension>        Edit each <file> in-place, saving backups with the specified
                        <extension>. If a zero-length extension is given (""), no
                        backup will be saved.
  -e <command>          Append <command> to the list of editing commands (may be
                        repeated).
  -f <command-file>     Append the editing commands found in the file <command-file>
                        to the list of editing commands (may be repeated). The editing
                        commands should each be listed on a separate line. The
                        editing commands are read from the standard input if 
                        <command-file> is “-”.
  --generate-manpage    Generate a man page.
  --version             Show version information.
  -h/--help             Show help information.

NOTES
  The sed-m utility reads each specified <file>, or the standard input if no <file>
  is specified, modifying the input as specified by a list of editing commands. The
  input is then written to the standard output.

  A single command may be specified as the first argument to sed-m, in which case no
  -e or -f options are allowed. Multiple commands may be specified by using the -e or
  -f options. All commands are applied to the input in the order they are specified
  regardless of their origin.

  Regular expressions are always interpreted as extended (modern) regular
  expressions.
```

</details>

<details>
<summary>Command Calls</summary>

```
> print foo foo > Foo.txt

> sed-m -i~ s/foo/bar/ Foo.txt -p
sed -E -i ~ -e s/foo/bar/ Foo.txt

> sed-m -i~ s/foo/bar/ Foo.txt

> cat Foo.txt Foo.txt~
bar foo
foo foo
```

</details>

<details>
<summary>Manual Page</summary>

The [MANPAGES directory](MANPAGES) contains the manual pages for this example.

After cloning, you can view the manual pages from the terminal. E.g.,

 cmd-arg-lib> man ./MANPAGES/sed-m.1
 
If you are not familiar with less, which is used to view manual pages, press "q" to exit.

</details>

---

## Modules

CAL has a modular design that makes it easier to customize and maintain. 

* CLI Definition
  * [CmdArgLibMacros](https://github.com/ouser4629/CmdArgLibMacros.git) uses macros to generate CLIs directly from ordinary Swift function declarations
  * [CmdArgLibCommandNodeStruct](https://github.com/ouser4629/CmdArgLibCommandNodeStruct.git) creates CLIs from conforming structs
* Command presentation
  * [CmdArgLibHelpScreen](https://github.com/ouser4629/CmdArgLibHelpScreen.git) provides help screen support
  * [CmdArgLibManpage](https://github.com/ouser4629/CmdArgLibManpage.git) provides manual page support
  * [CmdArgLibCompletions](https://github.com/ouser4629/CmdArgLibCompletions.git) provides shell completion support
* Support modules
  * [CmdArgLibTestSupport](https://github.com/ouser4629/CmdArgLibTestSupport.git) provides support for unit tests
  * [CmdArgLibTestSuite](https://github.com/ouser4629/CmdArgLibTestSuite.git) CAL's own unit tests
  * [CmdArgLibCore](https://github.com/ouser4629/CmdArgLibCore.git) provides support for all other CAL modules

Import what you need.

---

## Project Status

The library's [documentation](REFERENCE.md) is currently focused on terminology and API reference material. Additional tutorials and conceptual documentation are planned.

This software is licensed under the [Mozilla Public License, v. 2.0 "MPL-2.0"](https://mozilla.org/MPL/2.0).

The library is currently in beta (version 0.5.0), and currently has only been tested for macOS.

The library requires macOS 12. 

The [CmdArgLibMacros](https://github.com/ouser4629/CmdArgLibMacros.git) module 
should be built using Swift 6.2 or later. Earlier toolchains either do not support macros
or have unacceptable macro build performance.

## See Also

[CmdArgLibCore](https://github.com/ouser4629/CmdArgLibCore.git), 
[CmdArgLibMacros](https://github.com/ouser4629/CmdArgLIbMacros.git), 
[CmdArgLibCommandNodeStruct](https://github.com/ouser4629/CmdArgLibCommandNodeStruct.git), 
[CmdArgLibHelpScreen](https://github.com/ouser4629/CmdArgLibHelpScreen.git), 
[CmdArgLibManpage](https://github.com/ouser4629/CmdArgLibManpage.git), 
[CmdArgLibCompletions](https://github.com/ouser4629/CmdArgLibCompletions.git), 
[CmdArgLibTestSupport](https://github.com/ouser4629/CmdArgLibTestSupport.git) 
[CmdArgLibTestSuites](https://github.com/ouser4629/CmdArgLibTestSuites.git) 
