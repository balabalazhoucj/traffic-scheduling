#!/bin/sh
BaseBandwidth=$($(dirname $0)/describe_eip.sh | jq .EIPSet[1].Bandwidth)
. $(dirname $0)/send_sms.sh "18018356001|18912395059" "Steamserver当前已购买带宽为${BaseBandwidth}Mb"
