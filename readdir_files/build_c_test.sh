#!/bin/bash

set -x

clang --std=c89 -O0 -g creaddir_files.c -o creaddir_files.bin

./creaddir.bin
