#!/bin/bash

set -x

# clang --std=c89 -D_BSD_SOURCE -O0 -g creaddir_files.c -o creaddir_files.bin #  warning: "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE" [-W#warnings]
# _DEFAULT_SOURCE
clang --std=c89 -D_DEFAULT_SOURCE -O0 -g creaddir_files.c -o creaddir_files.bin

./creaddir_files.bin
