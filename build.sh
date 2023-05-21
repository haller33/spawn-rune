#!/bin/bash

set -x


if [ $# -eq 1 ]; then
    clang -std=c89 -g -D_DEFAULT_SOURCE -O3 \
        -c ./lib/readdir_files/creaddir_files.c -o ./lib/creaddir_files.a

    odin build src -debug -out:spawn_rune.bin && echo "OK"
else

    clang -std=c89 -D_DEFAULT_SOURCE -O3 \
        -c ./lib/readdir_files/creaddir_files.c -o ./lib/creaddir_files.a

    odin build src -out:spawn_rune.bin && echo "OK"
        # -o:speed && echo "OK"

fi
