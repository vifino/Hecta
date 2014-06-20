#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
screen -S Hecta -X quit
echo "Starting ]-[!"
screen -AdmS Hecta ./hecta $@