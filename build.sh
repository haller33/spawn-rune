#!/bin/bash

set -x

# clang -std=c89 -O2 -c creaddir.c -o creaddir.a
clang -std=c89 -O3 -c creaddir.c -o creaddir.a

odin build . && echo "OK"
