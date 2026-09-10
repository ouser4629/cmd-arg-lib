<!-- 
//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.
-->

# Command Argument Library Documentation

## Contents

<!-- TOC tocDepth:2..3 chapterDepth:2..6 -->

- [Features](#features)
- [Terminology](#terminology)
- [Macro-Based API](#macro-based-api)
  - [MainFunctionMacro](#mainfunctionmacro)
  - [CommandNodeMacro](#commandnodemacro)
- [Struct-Based API](#struct-based-api)
- [Command Function](#command-function)
  - [Command Function Parameter](#command-function-parameter)
  - [Label-Spec](#label-spec)
  - [Command Function Parameter Types](#command-function-parameter-types)
  - [CmdArgBasicType](#cmdargbasictype)
  - [Rest](#rest)
  - [Flag](#flag)
  - [Command Argument List](#command-argument-list)
  - [Stateful Command Function](#stateful-command-function)
- [CommandNode](#commandnode)
  - [Run Context](#run-context)
  - [Command Action](#command-action)
  - [Run Method](#run-method)
- [Hierarchical Commands](#hierarchical-commands)
  - [Command Tree](#command-tree)
  - [Simple Command Tree](#simple-command-tree)
- [Terminal IO](#terminal-io)
  - [Exception](#exception)
  - [Exception Pure](#exception-pure)
- [Meta-Parameters](#meta-parameters)
  - [Meta-Types](#meta-types)
  - [Show Elements](#show-elements)
  - [Synopsis Lines](#synopsis-lines)
  - [Synopsis Elements](#synopsis-elements)
  - [Show Macros](#show-macros)
  - [Help Screen](#help-screen)
  - [Manual Page](#manual-page)

<!-- /TOC -->

## Features

* Swift-based CLI definition
  * Defined CLIs mirror Swift function signatures
  * Defined CLIs follow Unix conventions, except, as in Swift
    * variadic arguments are allowed
    * except for flags, all arguments must have a value
* Modular design enforces separation of concerns
  * CmdArgLibCore - provides core functionality
  * CmdArgLibMacros - provides a macro-based API
  * CmdArgLibCommandNodeFrame - provides a protocol-based API
  * CmdArgLibHelpScreen - provides a help screen generator
  * CmdArgLibManpage - provides a manual page generator
  * CmdArgLibCompletions - provides completion script generators
* Run-time error reporting
  * Reusable error screens (for parser and user code)
  * Multiple syntax errors reported in a single pass
* Hierarchical command structures
  * State propagation
  * Tree diagram generation
* Compile-time error reporting (when using macros)
  * Duplicate short label names
  * Meta-flag parameters without default values
  * Parameter types not allowed by the library's macros
  * and more

---

## Terminology

When discussing the command argument library it is natural to use Swift terms
like parameter names, label names, types, default values, argument labels and argument values.

Consider this “command call,” a command’s name followed by five "words":
```
command-name -xy --verbose --name foo file
```

Depending on the shell, a word can include whitespace (e.g., when quoted).

Functions created using the library parse the words into [command arguments](#command-argument-list)
as follows:

* "-x", "-y" and "--verbose" are flags
* "--name foo" is a single labeled argument, not two arguments
* "file" is a "positional argument"

A flag, such as “-x”, “-y”, and “--verbose”, can be considered syntactic sugar for “-x true”, "-y true",
and “--verbose=true”. Ignoring syntactic sugar, a command argument is simply a label-value pair in which
the label may be omitted for positional arguments, exactly as in Swift.

It is important to note that the term [command argument](#command-argument-list) is not the same as
the term "argument" as defined in section 25.1.1, Program Argument Syntax Conventions,
of the [GNU C Library](https://www.gnu.org/software/libc/manual/html_mono/libc.html#Argument-Syntax).

* Every word passed in from the shell is an argument.
* Arguments are options if they begin with a hyphen. The rest are non-option arguments.
* Certain options require an argument.

It is common, however, to say “argument”, instead of “non-option” argument, “option” instead of
“option that requires an argument”, and “flag” or “switch” instead of “option” that does not require an argument.

To avoid confusion, the library uses the term [command argument](#command-argument-list), which is based on Swift
conventions.

---

## Macro-Based API

The macro-based API constists of two macros: `MainFunctionMacro` and `CommandNodeMacro`, both of which
are provided by the library's CmdArgLibMacros module.

### MainFunctionMacro

`MainFunctionMacro(shadowGroups: [String] = [])` generates code for non-hierachical CLIs.

It is a peer macro meant to annotate a [command function](#command-function)
that implements program logic. The macro generates a peer function, `run(with:)`, that is called with 
an array of words. If the words constitute a valid [command argument list](#command-argument-list), the parsed
values are passed to the annotated command function. Otherwise, the generated peer function throws an
[Exception](#exception).

The each string passed to the shadowGroups parameter contains the names of a group of CLI parameters that
override each other. If more than one member of a group appears in a command argument list, only the last one will be parsed.

The macro generates a peer function, `main()`, that fetches words passed in from the terminal and
passes them to the generated 'run(with:function)'. Any errors thrown by `run(with:` or by the command function, 
are caught and printed to stderr.

### CommandNodeMacro

`CommandNodeMacro<T>( shadowGroups: [String] = [], synopsis: String, children: [CommandNode<T>] = [])`
 is a peer macro that generates an instance of [CommandNode<T>](#commandnode). Trees of command nodes 
 are used to define hierachical CLIs. 
 
The macro is meant to annotate a [stateful command function](#stateful-command-function) that implements
program logic that will be associated with the generated command node.

A command node has a [run method](run-method) that processes command line arguments and state using the
annotated stateful command function, producing new state and remaining command line arguments. If the
node has children, the current node run method calls the appropriate child node's run function with
the returned state and remaining command line arguments.

---

## Struct-Based API

The struct-based API is based on `CommandNodeFrame`, a protocol provided by the library's `CmdArgLibCommandNodeFrame` module.

```swift
public protocol CommandNodeFrame: Sendable, Codable {
    associatedtype StateElement:Sendable
    init()
    var configuration: CommandNodeConfiguration<StateElement>? { get set }
    func run(state: [StateElement]) async throws -> [StateElement]
    static func main() async throws
    static var commandNode:CommandNode<StateElement> { get }
}
```

The user provides one stored property for each CLI argument, the `configuration` property and `run(state:)` method.
The protocol supplies `commandNode` and `main()`. The stored properties corresponding to CLI arguments
can have the same types as the parameters of a [command function](#command-function). All of the stored properties
must have a default value. For CLI arguments that are required, use an optional type wth a default value
of `nil`.

The configuration property provides information used by `CommandNodeFrame` to construct the instance
of `CommandNode<T>` it requires.

```swift
public init(commandName: String = "",
    shadowGroups: [String] = [],
    embellishments: [Embellishment] = [],
    commandSynopsis: String? = nil,
    children: [CmdArgLibCore.CommandNode<T>] = [])
```
---

## Command Function

A “command function” is a function whose parameters are [command function parameters](#command-function-parameter). It
can be public, internal, or private, be able to throw or not, and be synchronous or asynchronous. The macros handle all 
of this automatically. However, if it is a method it must be static.

A command function parameter's label, type and default value (if any), determine
the syntax of corresponding command arguments and how the corresponding arguments will be parsed.
There are no options (like parsing strategies). None. 

These items also determine how a parameter will be represented in generated help screens
and manual pages. In particular a parameter will be represented in a help screen or
manual page synopsis line within brackets if and only if it has an explicit or implicit default
value. Thus, for example, parameters with type `Flag`, `MetaFlag` or `Optional<Basic>` will always
appear within brackets.

---

### Command Function Parameter

A Swift function parameter has a label, a name, a type, and, optionally, a default value. A parameter
is a "command function parameter" if its label is a [label-spec](#label-spec) and its type is [command function type](#command-function).

---

### Label-Spec

A label-spec can contain only ascii alphanumeric characters and underscores, and must not start with a digit.
If a label-spec contains exactly two underscores, the underscores delimit three "label-names", used
to generate "short", "old-style" and "long" argument labels, like "-h", "-help" and "--help". Empty label-names
are ignored. The first label-name, if not empty, must be a single letter.

If a label-spec does not contain exactly two underscores, the entire label-spec will be treated as a single label-name.
If it consists of a single character, other than an underscore, it is used to generate a short label. If the single character
is an underscore, no label is generated. If the single label-name consists of more than one character, it is used to generate a long label.

Camelcased label-names, like "fileName" are converted to kebab-case, like "file-name".

---

### Command Function Parameter Types

These are the types allowed for command function parameters, where `B` is
any type that conforms to [`CmdArgBasicType`](#cmdargbasictype), and where `M` is 
any type that conforms to [MetaOptionElement][#metaoptionelement].

| Type            | Default Value      | Values Per Occurrence | Repeatable | Required in CLI Argument List |
|:----------------|:-------------------|:----------------------|:-----------|:------------------------------|
| `B`             | allowed            | 1                     | no         | when missing a default value  |
| `Array<B>`      | allowed, if `[]`   | 1                     | yes        | when missing a default value  |
| `Optional<B>`   | implicit - `nil`   | 1                     | no         | never                         |
| `Variadic<B>`   | allowed, if `[]`   | 1 or more             | no         | when missing a default value  |
| `Rest`          | allowed, if `[]`   | 1 or more             | no         | when missing a default value  |
| `Flag`          | implicit - `false` | 0                     | yes        | never                         |
| `MetaFlag`      | required           | 0                     | yes        | never                         |
| `MetaOption<M>` | required           | 1 or more             | no         | never                         |

Note that `Rest`, `Flag`, `MetaFlag` and `MetaOption<M>` do not conform to  [`CmdArgBasicType`](#cmdargbasictype).

As shown in the table, a parameter's type determines

* if a default value is allowed, implicitly defined, or required
* how many values are consumed by an associated command argument
* whether an associated command argument can appear more than once in a command argument list

If a parameter's type has an implicit value, it cannot be overridden.

`MainFunctionMacro` and `CommandNodeMacro<T>` enforce the type and default value requirements. Violations
are reported as compile time errors that, in Xcode for example, show up instantly during code editing.

The values per occurrence and printable traits are enforced by the parser and are reported in the library's
error screen at run time.

---

### CmdArgBasicType

Types that conform to `CmdArgBasicType` can be types of command function parameters. Out of the box, the
library provides four types that conform to `CmdArgBasicType`:

* String
* Int
* Double
* RawArg - a rarely used struct with low level parsing info

In addition, any `enum` that conforms to `CmdArgEnum` automatically conforms to `CmdArgBasicType`.

```swift
enum Mammal: String, CmdArgEnum { case cat, dog, cow }
```

It is easy to conform other types to `CmdArgBasicType`, but it is rarely useful.

___

### Rest

The type `Rest` is the same as `Variadic<String>` except that all words
that follow it are treated as elements of the array being parsed. These include "--", flags, meta-flags
and labeled values. Parameters with type `Rest` cannot be positional (i.e., they must have a label).

---

### Flag

`Flag` is simply a `typealias` for `Bool`. However, a command function parameter with type `Flag` must 
have a default value of `false`, defined implicitly or explicitly. The value of the parameter is set
to `true` if the parameter's corresponding command line argument is encountered in 
the [command argument list](#command-argument-list).

___

### Command Argument List

Typically a command argument list is the list of words passed in from the shell, excluding the
first word. The library's functions that parse command argument lists do not treat each word
as a command argument. For example, a single argument might consist of label followed by one or
more values.

In general a command argument consists of a label and a value, e.g. "--count 10". As in Swift,
the label can be omitted if the parameter is "positional". Arguments associated with flags and meta-flags
have no value, which is not allowed for arguments in Swift.

---

#### Associated Labeled Arguments and Parameters

A labeled command argument is associated with a labeled parameter, or stored variable, if the command argument's label
can be derived from the parameter or stored variable's label-spec.

A labeled parameter or stored variable "occurs" or "appears" in a command argument list if the list contains one or more
labeled command arguments that can be associated with the parameter or stored variable.

---

#### Associated Positional Arguments and Parameters

The parser associates positional command arguments with positional parameters as follows:

* The parser makes a first pass over all command arguments, assigning values to labeled parameters or labeled stored variables and flags.
* Each time the parser finds unconsumed values, up until the next label or end of arguments, it saves the values as a "value-array".
* After the first pass is completed, the parser assigns the values in the value-arrays to positional parameters
  * Start with the list of positional parameters, ordered as they appear in the command function
  * Take the first parameter, p, in the list of parameters
  * Take the first value-array, va, in the list of value-arrays
  * If either is empty - stop the assignment loop
    * if the list of parameters is empty and the list of value-arrays is not raise "unassigned value" error
    * if the list of parameters is not empty and the list of value-arrays is empty raise "unassigned parameter" error
  * If the p is variadic
    * assign all members of va to p
    * drop p and va from the front of their respective lists
  * Otherwise
    * assign the first element, v, of va to p
    * drop p from the front of its array and drop v from the front of va
    * if va is now empty, remove it from the value-array list
  * Repeat the assignment cycle
  
  
The net effect is that positional values are collected into value arrays and subsequently 
assigned to positional parameters independently of where labels occurred.

For example, the CLI has two positional parameters, with types
Variant<Color> and Variant<Animal> respetively.

```
> print-colors-and-animals red blue --uppercase cat dog
COLORS: RED BLUE
ANIMALS: CAT DOG
```

Most argument parsers would first parse `--uppercase` and then collect all four positional arguments as
a single array of values, rather than an array of value arrays. Parsing would fail because cat and dog
are not valid colors.

---

### Stateful Command Function

A stateful command function is the same as a normal [command function](#command-function) except that (a) its
last parameter must be `state: [T]`, and (b) it must return new state, an instance of `[T]`.

If a stateful command function is annotated by a `CommandNodeMacro` with child nodes, the command function cannot
have any positional parameters.

---

## CommandNode

A command node has a public `runContext` property, an internal `commandAction` property, and a public `run` method.

### Run Context

The `runContext` property is a parameterless function of type `RunContextFunction` that produces an
instance of `RunContext`. The `RunContext` produced by the `runContext` function is used by the library's 'error 
screen and by the [`MetaTypeFunction`](#metafunction) contained in instances of `MetaFlag` and `MetaOption`.


### Command Action

The `commandAction` property is a function that conforms to `CommandNodeAction<T>`: 

```swift
public typealias CommandNodeAction<T: Sendable> =
    @Sendable (
        [String],  // as yet unconsumed command argument list
        [T],  // state
        [CommandNode<T>]  // run path, ending with self
    ) async throws -> (
        [T],  // new state
        [String]  // remaining unparsed words, starting with first stop word encountered
    )
```

A command node's `commandAction` performs the node's program logic. It is called indirectly
via the node's public `run(with:state:parentNodes)` function.

The `commandAction` receives the 
portion of the top-level command-line arguments not consummed by parent nodes,
the state produced by its immediate parent, and the current chain of command nodes.
It returns new state and the unconsumed portion of command argument list.

A command node's `commandAction` is typically constructed by the library's `CommandMacro` or
by its `CommandNodeFrame` protocol.

---

### Run Method

Every command node has a public `run` method:

```swift
    @discardableResult public func run(
        with words: [String],
        state: [T] = [],
        parentNodes: [CommandNode] = []) async throws -> (newState: [T], unconsumedWords: [String])
    { ... }
```

The current node's method works as follows:

* perform program logic by passing its parameters to the node's `commandAction`, which
returns (newState, unconsumedWords)

* if the current node does not have child nodes, return (newState, unconsumedWords)

* if unconsumedWords is empty, throw a missing subcommand name Exception.

* let (newNodeName, newWords) = (unconsumed-words.first!, unconsumedWords.dropFirst(1))

* Look up newNodeName among the current node's children. If no child has that name, throw an appropriate exception

* let newParentNodes = parentNodes.append(currentNode)

* call newNode's `run` method with newWords, newState and newParentNodes

---


## Hierarchical Commands

### Command Tree

A “command tree” is a strict tree of [command nodes](#commandnode), i.e., a node can be reached
by only one path, beginning with a top-level node.

All instances of a given command tree must have the same type: `CommandNode<T>`, where `T` can be
any sendable type or `Void`.

A command tree is run  by calling the `run` method of its top-level node, passing
a [command argument list](#command-argument-list), an empty node path, and an empty state.

---

### Simple Command Tree

In many cases, the sole node that influences program logic when a top-level tree is executed is the final
node encountered. Consequently, all child nodes operate independently of any state passed by their parent nodes.

As a syntactic convenience for managing such “simple" command trees, the library defines `SimpleCommand`
as a typealias for `CommandNode<Void>`. Additionally, if `CommandNodeMacro<T>` annotates a command function
that lacks the `state` parameter and does not return a value, the macro will synthesize the `state` argument as `Void`.

---

## Terminal IO

### Exception

The library provides an enum, `Exception`, that conforms to `Error`, `CustomStringConvertible`, and `Sendable`.
It has four cases:

```swift
Exception.stdout(String)
Exception.stderr(String)
Exception.error(String)
Exception.errors([String])
```

It is often useful, and perhaps even a good habit, to have command functions throw Exception.stdout and Exception.stderr rather
than printing directly to standard output or standard error. 

`Exception` has a public static method `printAndExit(for error: Error)` that handles the `error` as follows:

* `Exception.stdout(_:String)` - prints the string to stdout and exits with EXIT_SUCCESS.
* `Exception.stderr(_:String)` - prints the string to stderr and exits with EXIT_FAILURE.
* `Exception.error(_:String)` - generates an error screen with the string and exits with EXIT_FAILURE.
* `Exception.errors(_:[String])` - generates an error screen with the strings, and exits with EXIT_FAILURE.

If the function is passed any other `Error`, it will 

* simplify the error's message
* generate an error screen with the message and callNames
* exit with EXIT_FAILURE

---

### Exception Pure

For lack of a better term, a function is "exception-pure" if 

* it either returns or throws an [Exception](#exception) that can be caught from its call site.  
* for a given input, it always either returns the same value or throws the same [exception](#exception).

If an exception-pure command function is annotated by `MainFunctionMacro` or `CommandNodeMacro<T>` the `run` function
generated by the macro will be also be exception-pure. This is especially useful for testing command line utilities using
Swift's Testing module and cmd-arg-lib's TestHelp.

The library provides `Exception.stdout`, `Exception.stderr`, `Exception.error` and
`Exception.errors` which allows text to be printed at the throwing command function's call site, rather than
from within the command function itself.

---

## Meta-Parameters

One of the library's most important design goals is separation of concerns. Accordingly,
meta-services like help screen generation, manual page generation and completion scripts
are provided by separate modules. Each such module defines a meta-flag or meta-option
constructor. Meta-flags and meta-options hold functions that are called when the meta-service is triggered.

### Meta-Types

The library provides two meta-types: `MetaFlag` and `MetaOption<M>`, where `M` conforms
to the `MetaOptionElement` protocol. 

Instances of `MetaFlag` and of `MetaOption<M>` have a stored property names `metaTypeFunction`
of type `[`MetaTypeFunction?`](#metafunction):

When a meta-flag or meta-option parameter is encountered during parsing:

* the parameter's default value's meta-type-function is called instead of the command function
* the `Exception` returned typically contains meta-info like a help screen, but can also indicate errors

A command function can contain any number of meta-flags and meta-options. Unlike ordinary parameters, meta-flags
and meta-options form an implicit shadow group, so that only the last meta-flag or meta-option will be triggered.

The library provides a few built-in `MetaFlag` initializers. These cover the most common uses:
help screens, man page generators, and text messages.

MetaFlag constructors produce their own meta-type functions based on their
parameters (e.g., an array of `ShowElement`).

A meta-option initializer has a parameter, `metaOptionElement` of type that conforms to [MetaOptionElement][#metaoptionelement], which
in turn has a property, `metaTypeFuncion` with type [`MetaTypeFunction?`](#metafunction) . The initializer uses the
`metaOptionElement` parameter's metaTypeFunction to initialize the new instance's metaTypeFunction.

#### MetaTypeFunction

```swift
public typealias MetaTypeFunction = @Sendable (
    [String],       // call names
    [String],       // associated parsed values if any
    RunContext      // info describing the annotated command function
) -> Exception
```

#### MetaOptionElement

```swift
public protocol MetaOptionElement {
    var metaTypeFunction: MetaTypeFunction? { get }
    var showElements: [ShowElement] { get }
}
```

___

### Show Elements

Show elements are used to lay out help screens and manual pages in terms of a prologue, text elements,
line elements, synopsis elements, rawValueLine elements, parameter description elements, and command
context elements.

A text element has an optional header and an optional body. The body is automatically
line-wrapped. The body can start on the same line as the header with hanging indent or on the line
after the header with basic indent, which defaults to 2. A line element is the same
except that the body is not line wrapped. (Especially useful for when laying out
a manual page). The bodies of text and line elements can contain [show macros](#show-macros).

A synopsis element has a header and an array of [synopsis lines](#synopsis-lines), where each synopsis line
is an array of [synopsis elements](#synopsis-elements). 


Each parameter description element has a parameter name and a parameter synopsis.
The synopsis can contain [show macros](#show-macros).
A parameter description element has a third field, used to provide hints to shell completion script generators.

A pseudo parameter element has name and a description. It formats the same as a parameter description. One
common use is list enum names and descriptions under a heading in a help screen or manpage.

A command context element is used to describe a subcommand.

---

### Synopsis Lines

Show element constructors for synopsis sections take a header and an array of synopsis lines, where
each line is an array of [synopsis elements](#synopsis-elements).

If a synopsis line list is empty except for one or more excluded parameter name specs, the names
of all the command function's parameters are appended to the list.

The excluded parameter names are collected and applied in a final pass to eliminate excluded parameters.

Synopsis line elements added by default are added in the order that they appear in the annotated command function
or conforming structs, as appropriate.

### Synopsis Elements

`SynoposisElement` is a typealias for `String`.

There are four types of synopsis elements, distinguished by prefixes:

* parameter name - like "color"
* dummy parameter specification - like "$c__color:Color=", "$c__color:Color?", "$\_:[File]", "f:Flag", etc.
* all parameters - like "$*"
* excluded parameter name - like "!color"

Except for the leading $ and the optional suffix "=", a dummy parameter element is the same as a parameter definition with no name.
I.e., "label:Type", where label is "\_", "foo", "f__foo", etc.
The "=" indicates that the dummy parameter should have a default value.

---

### Show Macros

It is often useful to insert a command function parameter's label, type or description in
help screen and manual page text. The library provides the following
"show macros", which can be inserted in text that appears in [show elements](#show-elements)
or in an error screen. When the show element or error screen is rendered, the macro will be expanded
appropriately.

There are eight show macros:

* `$S{<parameter-name>}` - the parameter's shortest label
* `$L{<parameter-name>}` - the parameter's longest label
* `$J{<parameter-name>}` - all of the parameter's labels joined
* `$T{<parameter-name>}` - the parameter's type
* `$E{<parameter-name>}` - the formatted type of the parameter's elements
* `$D{<parameter-name>}` - unformatted type of the parameter's elements
* `$F{<parameter-name>}` - formatted call names 
* `$N{<separator>}` - the program's call names joined by separator

In manual page text, the color of labels and types follows the rules prescribed by the mdoc utility.

If a parameter's type is `MetaOption<T>`, its element type name for show macro purposes
is that of `T`.

---

### Help Screen

A help screen made available by adding a "help meta-flag", a meta-flag that has a default
value initialized with `MetaFlag(helpElements: [ShowElement])`.

The [showElements](#show-elements) define the layout of text, synopsis lines, and parameter descriptions to be included
in the help screen.

By default, meta-flags are not included in the synopsis line, unless they have a short label,
in which case the short label is included. Parameters are represented
in the synopsis line in the order they appear in the command function, except that flags with
short names are packed at the front. Other parts of the help screen appear in the order that they appear
in the array of ShowElements.

Parameters that have an explicit or implicit default value are "optional", and are not required to appear 
in the command argument list. They are enclosed in brackets in the synopsis line. Those that do not have 
default values are "required", must appear at least once in the command argument list, and
are not enclosed in brackets.

Camelcased type names, like "FileName" are rendered like "<file-name>", i.e., converted to kebab-case and enclosed in angle-brackets.

The library cannot detect, at compile time, if a parameter
description has an unrecognized parameter name. If this is detected, at run time, the library
will stop your program and issue a "programmer error" message when the help meta-flag is triggered.

---

### Manual Page

The library can generate mdoc source documents, which can be rendered by man.

A manual page is defined by a meta-flag whose default value is an instance of `MetaFlag(mdocElements: [ShowElement])`.
The ShowElements are the same as for help screen meta-flags, except that the first two elements
must be a a prologue `ShowElement`, followed by a synopsis `ShowElement` with header "SYNOPSIS".
The prologue element, unique to manual page layouts, provides the description, date
and operating system info that mdoc requires.

Native "mdoc text" can be included in a show element array as line show elements. When converting an array
of help screen elements to an array of mdocElements, it is recommended that all .text
show element constructors (which line wrap) be converted to .paragraph constructors (which do not line wrap).

---
