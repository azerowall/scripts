# 0 - none
# 1 - error
# 2 - warning
# 3 - fixme
# 4 - info
# 5 - debug
# 6 - log
# 7 - trace
# 8 - memdump
#export GST_DEBUG=default:5,GST_CAPS:5

#export GST_DEBUG_FILE=/tmp/gstlog.log
#export GST_DEBUG_NO_COLOR=1

export GST_DEBUG_DUMP_DOT_DIR=dot/

mkdir -p $GST_DEBUG_DUMP_DOT_DIR

function gst_debug_make_svg(){
	rm $GST_DEBUG_DUMP_DOT_DIR/*.dot.svg
	dot -Tsvg -Osvg $GST_DEBUG_DUMP_DOT_DIR/*
	rm $GST_DEBUG_DUMP_DOT_DIR/*.dot
}
