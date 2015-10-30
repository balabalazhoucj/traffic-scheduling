#!/bin/sh
. /etc/init.d/functions

echo "----------$(date)------------------" >> BW.txt

Basepackage() 
{
	for ((i=0;i<${Bpackagenum};i++))
	do
		eipid=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .DataSets[$i].EIPId | sed 's/"//g')
		#echo "eipid:"$eipid >> BW.txt
		if [ "$eipid" = "eip-ucdn2z" ];then
			Bpackagewidth=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .DataSets[$i].Bandwidth)
			echo "当前带宽包[${i}]: ${Bpackagewidth}Mb" >> BW.txt
			BPW_total=$(($BPW_total+$Bpackagewidth))
		fi
	done
	echo "带宽包总计: ${BPW_total}Mb" >> BW.txt
}

#最近n次流量
n=5
count=0
offset=3
BW=($($(dirname $0)/get_metric.sh |jq '.DataSets.NetworkOut[].Value' | tail -$n | awk '{printf "%d\n",$1/1000/1000}'))
echo ${BW[@]} >> BW.txt
#echo $(date +%T --date="@$Time")

#算总增量包数
Bpackagenum=$($(dirname $0)/describe_bandwidthpackage.sh  | jq .TotalCount)
if [[ $Bpackagenum != 0 ]];then
	Basepackage
fi

BaseBandwidth="null"
while [ $BaseBandwidth = "null" ]
do
	sleep 5
	BaseBandwidth=$($(dirname $0)/describe_eip.sh | jq .EIPSet[1].Bandwidth)
	echo "默认带宽: ${BaseBandwidth}Mb" >> BW.txt
done

#参考带宽=基础带宽+总增量包数-offset
BW_total=$(($BPW_total+$BaseBandwidth-$offset))
echo "当前带宽阀值: ${BW_total}Mb" >> BW.txt

#判断最近5次流量是否大于参考量
for ((i=0;i<$n;i++))
do
	[[ ${BW[$i]} -ge $BW_total ]] && (( count++ ))
done
	
if [ $count = $n ];then
    echo '正在努力购买带宽。。。。。' >> BW.txt
    result=$($(dirname $0)/Create_BandwidthPackage.sh | jq .RetCode | sed 's/"//g')
   [ $result = 0 ] && echo '带宽包购买成功' >> BW.txt || echo '带宽包购买失败' >> BW.txt
else
    echo '带宽在合理范围内' >> BW.txt
fi

