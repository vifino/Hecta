#!/bin/bash
BINDIR=$(dirname "$(readlink -fn "$0")")
cd "$BINDIR"
screen -S Hecta -X quit
screen -AdmS Hecta lua main.lua
echo "Started ]-[!"