#!/bin/bash
#
# Wrapper on bin/compile script for handling basic general operations
#/
OUTPUT_DIR=${OUTPUT_DIR:-build}
PK=${PK:-scm.pk}

COMMAND=$1
shift

print_command() {
  echo -e "\e[32m"${1}"\e[0m"
}

DIR=`dirname ${BASH_SOURCE[0]}`
INPUT_FC=${DIR}/src/main.fc
EXEC=${DIR}/../bin/compile

case $COMMAND in
  init)
    command="${EXEC} -o $OUTPUT_DIR -k ${OUTPUT_DIR}/${PK} $INPUT_FC $@ -m messages/init.fif.sh"
    print_command "$command"
    echo
    ${command}
    ;;
  upgrade)
    command="${EXEC} -o $OUTPUT_DIR/1 -k ${OUTPUT_DIR}/${PK} $INPUT_FC -a $OUTPUT_DIR/main.addr -m messages/upgrade-scm.fif.sh $@"
    print_command "$command"
    echo
    ${command}
    ;;
  transfer)
    command="${EXEC} -o $OUTPUT_DIR/1 $INPUT_FC -m messages/transfer.fif.sh --skip-fc $@"
    print_command "$command"
    echo
    ${command}
    ;;
  -h|--help|help|*)
    echo "This is a script for simplifying general operations of the Bounty smart contract"
    echo "It creates all files into **$OUTPUT_DIR** dir"
    echo "If you would like to change predefined parameters - use env varialbes:"
    echo " * OUTPUT_DIR"
    echo " * PK"
    echo
    echo Usage: ./build COMMAND
    echo
    echo COMMANDS:
    echo "  init OPTIONS...             create initialization message"
    echo "                                OPTIONS: ./build.sh init -h"
    echo "  upgrade OPTIONS...          create upgrade code message [DANGER]"
    echo "                                OPTIONS: ./build.sh upgrade -h"
    echo "  transfer OPTIONS...         create transfer grams message"
    echo "                                OPTIONS: ./build.sh transfer -h"
    echo
    echo "  help                        reads this message"

    ;;
esac
