#!/bin/sh
#./send_sms.sh "1300000001|13000000002" message

oldlist="Action=SendSms Content=$2"
#oldlist="Action=SendSms Content=$1 Phone.1=18018356001"
phone=$(awk -v canshu=$1 'BEGIN{info=canshu;split(info,a,"|");for(k in a){sum=("Phone."k"="a[k])" "sum;}{print sum;}}')
oldlist=${oldlist}" "${phone}
. $(dirname $0)/core.sh
