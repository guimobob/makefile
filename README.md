Makefile
========

The point of this makefile is to have a simple makefile for small or tests
programs without having to always create a new Makefile from scratch or using
GNU Autotools.

This makefile can compile any c code into an executable. All you have to do is
modify the `TARGET` variable at the beginning of the script.

usage: `make` or `make release`

Features
========

It support the building of both x86 and x86-64 architecture, but you need to
have gcc-multilib installed.

Only a few minor change are needed to compile it into a library.

The makefile keep tracks of file changes and recompile only the required files.

Notes
=====

Be careful, it doesn't keep changes made to the makefile itself or if you
changed to a different OS/architecture.

There is no support for sub-directories.
