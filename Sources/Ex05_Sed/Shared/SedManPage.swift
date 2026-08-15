//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibManpage

public let manpageMetaFlag = MetaFlag(manpageElements: manpageLayout)

private let manpageLayout: [ShowElement] = [
    // The prologue (with name section)
    .prologue(description: "wrap sed to demonstrate use of manpage support"),

    // The synopsis
    .synopsis(lines: [synopsisLine1Names, synopsisLine2Names]),

    // The description
    .mdoc("DESCRIPTION", description01),
    .mdoc("", description02),
    .mdoc("", "The following options are available:"),
    .parameter("commands", commands),
    .parameter("commandFiles", commandRun),
    .parameter("inplace", inplaceEdit),
    .parameter("quiet", quiet),
    .parameter("preview", preview),
    .mdoc("", note1),

    // Other sections
    .mdoc("", exitStatus),
    .mdoc("", sedExamples),
    .mdoc("", seeAlso),
    .mdoc("", authors),
]

private let exitStatus = """
    .Sh EXIT STATUS
    The $F{-} utility exits 0 on success, and >0 if an error occurs.
    """

private let sedExamples = """
   .Sh EXAMPLES
   Replace
   .Ql bar
   with
   .Ql baz
   when piped from another command:
   .Bd -literal -offset indent
   echo "An alternate word, like bar, is sometimes used in examples." | $N{-}  's/bar/baz/'
   .Ed
   .Pp
   Using backlashes can sometimes be hard to read and follow:
   .Bd -literal -offset indent
   echo "/home/example" | $N{-}  's/\\/home\\/example/\\/usr\\/local\\/example/'
   .Ed
   .Pp
   Using a different separator can be handy when working with paths:
   .Bd -literal -offset indent
   echo "/home/example" | $N{-} 's#/home/example#/usr/local/example#'
   .Ed
   .Pp
   Replace all occurrences of
   .Ql foo
   with
   .Ql bar
   in the file
   .Ql  test.txt
   without creating a backup of the file:
   .Bd -literal -offset indent
    $N{-} -i '' -e 's/foo/bar/g' test.txt
   .Ed
   """

private let seeAlso = """
    .Sh SEE ALSO
    .Xr man 1 ,
    .Xr mandoc 1 ,
    .Xr sed 1 ,
    .Xr mdoc 7 ,
    .Xr re_format 7   
    .Rs
    .\" 4.4BSD USD:15
    .%A Lee E. McMahon
    .%I AT&T Bell Laboratories
    .%T SED \\(em A Non-interactive Text Editor
    .%R Computing Science Technical Report
    .%N 77
    .%D January 1979
    .Re
    """

private let authors = """
    .Sh AUTHORS
    The sed utility wrapped by $F{-}, was written by
    .%A Diomidis D. Spinellis <dds@FreeBSD.org> .
    .Pp
    The $F{-} utiility was written (with help screen and manual page text lifted 
    from the sed utiltiy's manual page) by 
    .%A Peter Buenafuente Summerland 
    """
