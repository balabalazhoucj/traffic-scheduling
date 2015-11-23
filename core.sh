#!/bin/sh
#已经支持osx和centos环境运行
if [ -f $(dirname $0)/base.sh ];then
	. $(dirname $0)/base.sh
else
	echo "请先在同层目录新建一个base.sh文件，用于存放密钥"
fi

#signature string
signlist=$(echo $oldlist" PublicKey=$public_key"|sed 's/ /\'$'\n/g;s/=//g'| sort -k1 | awk -v FS='\n' -v ORS='' '$1=$1')$private_key
signature=$(/bin/echo -n "$signlist" | sha1sum)
signature=${signature:0:40}

#http request string
httplist=$(echo $oldlist" PublicKey=$public_key"|sed 's/ /\'$'\n/g'| sort -k1|sed 's/^/\&/g' | awk -v FS='\n' -v ORS='' '$1=$1' )"&Signature=$signature"
httpurl=$(echo $httplist | sed 's/\&//')

#echo "https://api.ucloud.cn/?$httpurl"

curl -s -d $httpurl https://api.ucloud.cn
