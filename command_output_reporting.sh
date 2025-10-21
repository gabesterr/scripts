#!/bin/bash

# this script accepts 3 parameters
# $1 = command to run
# $2 = text to parse from the command output
# $3 = report sequence e.g. cut -d. -f1 or "awk '{print \$NF}'"

if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] ; then
  echo "Usage: $0 <my_command> <parse_output> <format_report>" 
  exit 1
fi

myCommand="${1}"
myParse="${2}"
myFormat="${3}"

# capture command output
myData="$(${myCommand})"

echo "Data being processed: ${myData} | ${myParse} | ${myFormat}"

# Warning: Using 'eval' is generally discouraged unless input is trusted. 
# Risks unintended consequences from unexpected input including security compromise.

myResult=$(echo "${myData}" | grep "${myParse}" | eval "${myFormat}")

echo "Result is ${myResult}"
