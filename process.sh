#!/bin/sh
echo "----------$(date)------------------" >> BW.txt

Basepackage() 
{
	#算总增量包数
	Bpackagenum=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .TotalCount)
	[ $Bpackagenum = 0 ] && return
	for ((i=0;i<${Bpackagenum};i++))
	do
		eipid=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .DataSets[$i].EIPId | sed 's/"//g')
		echo "eipid:"$eipid >> BW.txt
		if [ "$eipid" = "eip-ucdn2z" ];then
			echo "BPW_total:"$BPW_total >> BW.txt
			Bpackagewidth=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .DataSets[$i].Bandwidth)
			echo "Bpackagewidth:"$Bpackagewidth >> BW.txt
			BPW_total=$(($BPW_total+$Bpackagewidth))
		fi
	done
}

#最近n次流量
n=5
count=0
offset=0
BW=($($(dirname $0)/get_metric.sh |jq '.DataSets.NetworkOut[].Value' | tail -$n | awk '{printf "%d\n",$1/1024/1024}'))
echo ${BW[@]}
#echo $(date +%T --date="@$Time")

Basepackage

BaseBandwidth="null"
while [ $BaseBandwidth = "null" ]
do
	sleep 5
	BaseBandwidth=$($(dirname $0)/describe_eip.sh | jq .EIPSet[1].Bandwidth)
	echo "BaseBandwidth:"$BaseBandwidth >> BW.txt
done

#参考带宽=基础带宽+总增量包数-offset
echo "BPW_total:"$BPW_total >> BW.txt
BW_total=$(($BPW_total+$BaseBandwidth-$offset))
echo "Bandwidth now: "$BW_total"Mb" >> BW.txt

#判断最近5次流量是否大于参考量
for ((i=0;i<$n;i++))
do
	[ ${BW[$i]} -ge $BW_total ] && (( count++ ))
done
	
if [ $count = $n ];then
    echo 'bad' >> BW.txt
    result=$($(dirname $0)/Create_BandwidthPackage.sh | jq .RetCode | sed 's/"//g')
   [ $result = 0 ] && echo '购买成功' >> BW.txt || echo '购买失败' >> BW.txt
else
    echo 'good' >> BW.txt
fi

