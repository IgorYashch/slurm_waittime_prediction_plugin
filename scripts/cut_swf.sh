#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 input_file output_file num_lines"
    exit 1
fi

input_file="$1"
output_file="$2"
n="$3"

awk -v n="$n" '!/^[[:space:]]*;|^$/ && c++ < n' "$input_file" > "$output_file"
