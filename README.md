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

* Use the library's macro-based API to turn ordinary Swift functions into command-line commands with one line of code:

```swift
@main
struct Main {
    @MainFunctionMacro
    static public func printM (
        h__help: MetaFlag = MetaFlag(helpElements: helpLayout),
        l: Flag,
        u: Flag,
        count: Int = 1,
        phrase: String)
    { ... }
}
```

* Alternatively, use its struct-based API:

```swift
@main
struct Main: CommandNodeFrame {
    var h__help: MetaFlag = MetaFlag(helpElements: helpLayout)
    var l: Flag = false
    var u: Flag = false
    var count: Int = 1
    var phrase: String? = nil

    var configuration: CommandNodeConfiguration<Void>? = CommandNodeConfiguration<Void>(
        commandName: "print-s",
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
    .parameter("h__help", "Show help information"),
    .parameter("l", "Lowercase the output"),
    .parameter("u", "Uppercase the output"),
    .parameter("count", "The number of times to print the phrase"),
    .parameter("phrase", "The phrase to print"),
]
```

CLIs defined using CAL mimic Swift, yet feel natural to shell users.

Help screens and manual pages are built from composable show elements, rather than from fixed templates.

Together, these features provide a direct mapping from Swift APIs to command-line interfaces while supporting conventional help screens and manual pages.

---

## Usage

This repository includes five examples designed to demonstrate almost all of CAL's features.

The examples are intended to be edited, say in Xcode, and then built and run from the terminal.

<details>
<summary>Install</summary>

```
> rm -rf Demo && mkdir Demo && cd Demo
Demo> git clone https://github.com/ouser4629/cmd-arg-lib.git
Demo> cd cmd-arg-lib
cmd-arg-lib> swift build -c release
```

After this, the example executables can installed, one by one, as follows:

```
cmd-arg-lib> cd .build/release
release> cp print-m ~/.local/bin
release> cp print-s ~/.local/bin

release> cp person-m ~/.local/bin
release> cp person-s ~/.local/bin

release> cp run-m ~/.local/bin
release> cp run-s ~/.local/bin

release> cp advice-m ~/.local/bin
release> cp advice-s ~/.local/bin

release> cp sed-m ~/.local/bin
release> cp sed-s ~/.local/bin
cd ../..
cmd-arg-lib>
```

</details>

<details>
<summary>Edit and Run</summary>

Assuming you are interested in one example, say `person-m`, you can run this after
each edit:

```
cmd-arg-lib> swift build -c release && cp .build/release/person-m ~/.local/bin
```

</details>

---

## Examples

Each example is implemented twice, first with CAL's macro-based API, and then with its struct-based API.

### 1 - Print

This example, presented above, prints a phrase.

It demonstrates basic usage.

<details>
<summary>Help Screen</summary>

```
cmd-arg-lib> print-m -h
DESCRIPTION
  Print a phrase multiple times.

USAGE
  print-m [-hlu] [--count <int>] --phrase <string>

PARAMETERS
  -h/--help             Show help information.
  -l                    Lowercase the output.
  -u                    Uppercase the output.
  --count <int>         The number of times to print the phrase (default: 1).
  --phrase <string>     The phrase to print.
```

</details>

<details>
<summary>Command Calls</summary>

```
> print-m --count 2 --phrase "Hello world!"
Hello world!

> print-m -lu --phrase "Hello world!"
HELLO WORLD!

> print-m -xuxxylzz --count 2.1
Errors:
  unrecognized options: "-x", "-y" and "-z", in "-xuxxylzz"
  missing an occurrence of the "--phrase" option
  "2.1" is not a valid <int> after --count
See "print-m --help" for more information.
```

</details>

---

### 2 - Person

This example collects and prints a person's personal information.

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

This example optionally prints a comment before running a command with `Process`.

It demonstrates:

* using [Exception](REFERENCE.md#exception) to write to CAL's error screen, standard output
  and standard error in [exception-pure](REFERENCE.md#exception-pure) functions
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
  missing an occurrence of the "--command" option
  unassigned arguments: "ls" and "-1"
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
# Rest collects all subsequent arguments verbatim
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

This test is commented out because it is designed to fail.

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
will run the example with the indicated input, just as if it were run from the terminal. For example:

```
> touch xcode zed

> run-m -v 'Actual comment' --command ls -1
Actual comment
ls -1
---
xcode
zed
```

But the test expects `run-m` to produce this:

```
> run-m -v 'Actual comment' --command ls -1
Expected comment
ls -1
---
vscode
zed
```

If the defective test is uncommented, swift test reports the mismatch in diff format:

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
------ END MISMATCH --- ("+" and "-" indicate changes to expected to match actual)
✘ Test defectiveTest() recorded an issue at Ex03_MacrosTests.swift:123:13: Expectation failed: ok
✘ Test defectiveTest() failed after 0.100 seconds with 1 issue.
```

See [CmdArgLibTestSuites](https://github.com/ouser4629/CmdArgLibTestSuites.git) for numerous examples.

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
## Correct command call
> advice-m --upper quotes general --count 2
QUOTES
  WELL DONE IS BETTER THAN WELL SAID. - BENJAMIN FRANKLIN
  SIMPLICITY IS COMPLEXITY RESOLVED. - CONSTANTIN BRANCUSI

## Parser stops at first command with an error, `advice-m `
> advice-m --upper -c green quotes general --count 2.0
Error:
  "green" is not a valid <color> after -c
See "advice-m --help" for more information.

## Parser stops at lower level
> advice-m --upper quotes general --count 2.0
Error:
  "2.0" is not a valid <count> after --count
See "advice-m quotes general --help" for more information.
```

</details>

---

### 5 - Sed Wrapper

This example wraps sed.

It demonstrates more advanced usage, including
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
> echo foo foo > Foo.txt

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

After cloning the repository, you can view the manual pages from the terminal. For example:

```
cmd-arg-lib> man ./MANPAGES/sed-m.1
```

If you are not familiar with less, which is used to view manual pages, press "q" to exit.

</details>

---

## Modules

CAL has a modular design that makes it easier to customize and maintain.

* CLI Definition
  * [CmdArgLibMacros](https://github.com/ouser4629/CmdArgLibMacros.git) provides macros to generate CLIs directly from ordinary Swift function declarations
  * [CmdArgLibCommandNodeFrame](https://github.com/ouser4629/CmdArgLibCommandNodeFrame.git) provides a protocol to generate CLIs from conforming structs
* Command presentation
  * [CmdArgLibHelpScreen](https://github.com/ouser4629/CmdArgLibHelpScreen.git) provides help screen support
  * [CmdArgLibManpage](https://github.com/ouser4629/CmdArgLibManpage.git) provides manual page support
  * [CmdArgLibCompletions](https://github.com/ouser4629/CmdArgLibCompletions.git) provides shell completion support
* Support modules
  * [CmdArgLibTestSupport](https://github.com/ouser4629/CmdArgLibTestSupport.git) provides support for unit tests
  * [CmdArgLibTestSuites](https://github.com/ouser4629/CmdArgLibTestSuites.git) contains CAL's own unit tests
  * [CmdArgLibCore](https://github.com/ouser4629/CmdArgLibCore.git) provides support for all other CAL modules

Import what you need.

---

## Project Status

The library's [documentation](REFERENCE.md) focuses on terminology and API reference material.

This software is licensed under the [Mozilla Public License, v. 2.0 "MPL-2.0"](https://mozilla.org/MPL/2.0).

The library is in beta (version 0.5.1) and has been tested only on macOS.

All CAL modules require macOS 12 or later.

The [CmdArgLibMacros](https://github.com/ouser4629/CmdArgLibMacros.git) module
should be built using Swift 6.2 or later. Earlier toolchains either do not support macros
or have unacceptable macro build performance.
