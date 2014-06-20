#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
screen -S Hecta -X quit
screen -AdmS Hecta ./hecta
echo "Started ]-[!"