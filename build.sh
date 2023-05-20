#!/bin/bash

set -x

clang -std=c89 -D_DEFAULT_SOURCE -O3 \
    -c ./lib/readdir_files/creaddir_files.c -o ./lib/creaddir_files.a

odin build src -out:spawn_rune.bin && echo "OK"
