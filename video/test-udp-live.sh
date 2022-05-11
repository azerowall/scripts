#!/bin/bash

if [[ "$1" == "h" ]] ; then
	echo "Usage: <ENV_ARGS> $0"
	echo "Args: HOST, PORT, USE (ff or gst)"
	exit
fi

host="${HOST:-239.1.1.1}"
port="${PORT:-1234}"
use="${USE:-gst}"

if [[ "$use" != "gst" ]] ; then
	use="ff"
fi

gst () {
  VENC="x264enc"
  #VENC="x265enc"
  #VENC="avenc_mpeg1video"
  #VENC="avenc_mpeg2video"

  #AENC="avenc_mp2"
  AENC="lamemp3enc ! mpegaudioparse"
  #AENC="avenc_ac3"

  SRC="videotestsrc ! videoconvert ! $VENC ! mpegtsmux name=mux"
  SRC="$SRC audiotestsrc ! audioconvert ! $AENC ! mux. mux."

  SINK="udpsink host=$host port=$port"

  P="$SRC ! $SINK"
  echo "$P"
  gst-launch-1.0 --verbose $P 2>&1
}

ff () {
  duration=1000

  ffmpeg -re \
    -f lavfi -i "sine=duration=$duration:frequency=1000" \
    -f lavfi -i "testsrc=duration=$duration:size=1280x720" \
    -metadata title=Bla1 \
    -c:a mp3 \
    -metadata:s:a:0 language=eng \
    -c:v libx264 \
    -metadata:s:v:0 language=nld \
    -f mpegts "udp://$host:$port?pkt_size=1316"
}

echo "Stream on udp://$host:$port"
if [[ "$use" == "gst" ]] ; then
  gst
else
  ff
fi
