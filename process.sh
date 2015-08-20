#!/bin/sh
. /etc/profile
echo "----------$(date)------------------" >> BW.txt

#最近10分钟流量
for ((i=0;i<5;i++))
do
	n=$((22-i))
	Time=$($(dirname $0)/get_metric.sh | jq .DataSets.NetworkOut[$n].Timestamp)
    #把最近5次流量放入到数组中
	BW[$i]=$(($($(dirname $0)/get_metric.sh | jq .DataSets.NetworkOut[$n].Value)/1024/1024))
	#转换unix时间，并打印时间和流量
	echo $(date +%T --date="@$Time") ${BW[$i]}Mb >> BW.txt
done

#算总增量包数
Bpackagenum=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .TotalCount)
BaseBandwidth=$($(dirname $0)/describe_eip.sh | jq .EIPSet[1].Bandwidth)
for ((i=0;i<${Bpackagenum};i++))
do
	eipid=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .DataSets[$i].EIPId | sed 's/"//g')
    if [ "$eipid" = "eip-ucdn2z" ];then
		Bpackagewidth=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .DataSets[$i].Bandwidth)
		BPW_total=$(($BPW_total+$Bpackagewidth))
	fi
done

#参考带宽=基础带宽+总增量包数-5
BW_total=$(($BPW_total+$BaseBandwidth-5))
echo $BW_total >> BW.txt
#判断最近5次流量是否大于参考量
if [ ${BW[0]} -ge $BW_total -a ${BW[1]} -ge $BW_total -a ${BW[2]} -ge $BW_total -a ${BW[3]} -ge $BW_total -a ${BW[4]} -ge $BW_total ];then
    echo 'bad' >> BW.txt
    result=$($(dirname $0)/Create_BandwidthPackage.sh | jq .RetCode | sed 's/"//g')
   [ $result = 0 ] && echo '购买成功' >> BW.txt || echo '购买失败' >> BW.txt
else
    echo 'good' >> BW.txt
fi

