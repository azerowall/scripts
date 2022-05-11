#!/bin/bash

if [ $# -lt 2 ] ; then
	echo "Usage: $0 quality input_dir output_dir"
	exit
fi

Q="$1"
DIR="$2"
OUT_DIR="$3"

for file in ${DIR}*.heic ; do
	echo $file
	heif-convert -q "$Q" "$file" "${OUT_DIR}/${file}.jpg" #"${file/%.heic/.jpg}"
done
