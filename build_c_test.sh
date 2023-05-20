#!/bin/bash

set -x

clang --std=c89 -O0 -g creaddir.c -o creaddir.bin

./creaddir.bin
