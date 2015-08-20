#!/bin/sh
#[ -f base.sh ] || echo "请先在同层目录新建一个base.sh文件，用于存放密钥"

. $(dirname $0)/base.sh

#signature string
signlist=$(echo $oldlist" PublicKey=$public_key"|sed 's/ /\n/g;s/=//g'| sort -k1 | awk -vFS='\n' -vORS='' '$1=$1')$private_key
signature=$(echo -n "$signlist" | sha1sum)
signature=${signature:0:40}

#http request string
httplist=$(echo $oldlist" PublicKey=$public_key"|sed 's/ /\n/g'| sort -k1|sed 's/^/\&/g' | awk -vFS='\n' -vORS='' '$1=$1' )"&Signature=$signature"
httpurl=$(echo $httplist | sed 's/\&//')

#echo "https://api.ucloud.cn/?$httpurl"

curl -s -d $httpurl https://api.ucloud.cn
