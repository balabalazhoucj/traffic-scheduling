#!/bin/sh
oldlist="Action=CreateBandwidthPackage Region=cn-east-01 EIPId=eip-ucdn2z Bandwidth=10 EnableTime=$(date +%s) TimeRange=1"
. $(dirname $0)/core.sh


