#!/bin/bash
#
# Wrapper on bin/compile script for handling basic general operations
#/
OUTPUT_DIR=build
PK=scm.pk
INPUT_FC=src/main.fc

COMMAND=$1
shift

print_command() {
  echo -e "\e[32m"${1}"\e[0m"
}

case $COMMAND in
  init)
    ;;
  -h|--help|help|*)
    echo "This is a script for simplifying general operations of the Bounty smart contract"
    echo "It creates all files into **$OUTPUT_DIR** dir"
    echo "If you would like to change predefined parameters - open the file and edit constants:"
    echo " * OUTPUT_DIR"
    echo " * PK"
    echo
    echo Usage: ./build COMMAND
    echo
    echo COMMANDS:
    echo "  init                        create initialization message"
    echo
    echo "  help                        reads this message"

    ;;
esac
