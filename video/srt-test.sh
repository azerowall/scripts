#!/bin/bash

srtsink () {
  gst-launch-1.0 \
      videotestsrc ! videoconvert ! x264enc ! mpegtsmux name=mux\
      mux. ! srtsink $srt_params
}

srtsrc () {
  gst-launch-1.0 \
    srtsrc $srt_params name=src \
    src. ! queue ! tsdemux ! decodebin ! videoconvert ! autovideosink
}

element=${1:-'sink'}
mode=${2:-'listener'}
host=${HOST:-'127.0.0.1'}
port=${PORT:-1234}

passphrase="0123456789"
pbkeylen=0

listener="localaddress=0.0.0.0 localport=$port mode=listener"
#listener="mode=listener localport=1234"
#listener="mode=listener uri=srt://127.0.0.1:1234"
#listener="mode=listener uri=srt://:1234"

caller="uri=srt://$host:$port mode=caller"
#caller="mode=caller uri=srt://:1234"
#caller="mode=caller localaddress=127.0.0.1 localport=1234"

#rendezvous="uri=srt://$host:$port?mode=rendez-vous"
#rendezvous="mode=rendezvous localaddress=$host localport=$port"

# rendezvous1="mode=rendezvous localaddress=0.0.0.0 localport=8000 uri=srt://127.0.0.1:8001"
# rendezvous2="mode=rendezvous localaddress=0.0.0.0 localport=8001 uri=srt://127.0.0.1:8000"

# mode=caller
rendezvous="uri=srt://$host:$port?mode=rendezvous&localaddress=0.0.0.0&localport=$port"

# Failed to open SRT: Operation not supported: Cannot call connect on UNBOUND socket in rendezvous connection setup
# rendezvous="uri=srt://$host:$port mode=rendezvous localaddress=0.0.0.0 localport=$port"

# rendezvous="uri=srt://$host:$port?mode=rendezvous localaddress=0.0.0.0 localport=$port"

if [[ "$mode" == "caller" ]] ; then
  srt_params="$caller"
elif [[ "$mode" == "listener" ]] ; then
  srt_params="$listener"
elif [[ "$mode" == "rendezvous" ]] ; then
  srt_params="$rendezvous"
else
  echo "Unknown mode $mode"
  return 1
fi
echo "SRT params $srt_params"

if [[ "$element" == "sink" ]] ; then
  cmd=srtsink
elif [[ "$element" == "src" ]] ; then
  cmd=srtsrc
else
  echo 'Unknown element'
  exit 1
fi

export GST_DEBUG=*srt*:5
export GST_DEBUG_DUMP_DOT_DIR="$(pwd)/dot/"
mkdir -p "$GST_DEBUG_DUMP_DOT_DIR" > /dev/null
rm "${GST_DEBUG_DUMP_DOT_DIR}/*.dot*" 2> /dev/null

srt_params="$srt_params" $cmd 2>&1 \
| grep --color=always -i -e "Opening SRT" -e "Binding to" -e "Connect" -e "uri" -e "rendezvous" -e "caller"