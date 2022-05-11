#!/bin/bash

if [[ $# -lt 1 ]] ; then
	echo "Usage: $0 path [host [port ['gst' | 'ff']]]"
	exit
fi

path="$1"
host="${2:-239.1.1.1}"
port="${3:-1234}"
use="${4:-ff}"

echo "Stream at udp://$host:$port"
if [[ "$use" != "gst" ]] ; then
	use="ff"
fi

if [[ "$use" == "gst" ]] ; then
	gstversion=$(gst-launch-1.0 --version | grep GStreamer | cut -d' ' -f2)
	echo "Gstreamer $gstversion"
	# TODO: alignment property available since 1.18.0
	gst-launch-1.0 filesrc location="$path" ! tsparse alignment=7 ! udpsink host="$host" port="$port" sync=true
else
	ffmpeg -re -i "$path" -vcodec copy -acodec copy -f mpegts "udp://$host:$port?pkt_size=1316"
fi

