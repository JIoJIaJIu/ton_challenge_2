#!/bin/bash
#
# Parses #include "file" notation
#

INPUT_FC=$1
PARSED_FILES=/tmp/parsed_files
CLOSURE=${BASH_SOURCE[0]}

parse_file() {
  file_realpath=$1
  file_dir=`dirname $1`
  parsed_files=$2

  IFS=''
  while read -r line; do
    if [[ $line == "#include"* ]]; then
      file=$(echo $line | awk '/#include "(.*?)"/{print $2}')
      file=${file:1:-2}
      if [[ $file != *".fc" ]]; then
        file+=.fc
      fi
      file=`realpath ${file_dir}/${file}`
      if [[ "$(cat $parsed_files)" =~ "$file" ]]; then
        continue
      fi
      file_source=$(parse_file $file $parsed_files)
      echo $file >> $parsed_files
      echo -e "$file_source"
    else
      echo -e "$line"
    fi
  done < $file_realpath
}

touch $PARSED_FILES 
parse_file `realpath $INPUT_FC` $PARSED_FILES
rm $PARSED_FILES
