#!/bin/bash


dotshow () {
	path="$1"
	if [[ "$path" == *":"* ]]; then
		rpath="$path"
		path="/tmp/$(basename $rpath)"
		scp "$rpath" "$path"
	fi
	dot "$path" -Tsvg -Osvg && xdg-open "$path.svg"
}

for f in "$@" ; do
	dotshow "$f"
done
