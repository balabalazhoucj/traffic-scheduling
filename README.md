# ucloud带宽自动调度机制:

目的：把原本根据监控报警后手动购买带宽包变为自动；凌晨项目基本不使用，此时可以自动地把带宽降低到一定的值（10M），节省开支；在客户上班前把带宽自动提升到基准值，整个升降带宽过程对客户是透明的。

此机制具体过程描述如下：
1.	基准带宽设置为50M

2.	每晚23:00调度启动，带宽降至10M

3.	每日7:00调度启动，带宽增至50M（基准带宽）

4.	7点-23点间，调度机制会每5分钟对过去10分钟内带宽进行评估，10分钟（150秒）内会有一次带宽峰值记录，也就是10分钟内有5次采样结果输出。如果此5次结果均大于预设阀值带宽，会触发带宽购买服务，调度机制会购买1小时10M带宽包（0.75元/次）。如果在购买后5次带宽采样均大于60M（50M+10M-offset），会再次购买一小时10M带宽。直至采样中有一次低于评估量（基准带宽+n个带宽包×10M-offset）


使用方法：

在同层目录新建一个base.sh文件，在base.sh中，添加如下内容

	#!/bin/sh
	public_key=ucloud账户公钥
	private_key=ucloud账户私钥

### token模块	

    core.sh

### 带宽增加模块

    Create_BandwidthPackage.sh

### 获取带宽包模块
    
    describe_bandwidthpackage.sh
    
### 获取EIP信息模块

    describe_eip.sh

### 获取ULB信息模块

    describe_ulb.sh

### 获取最近一小时内每150秒流量

    get_metric.sh

### 离线流量，10M

    modify_eipbandwidth_offline.sh

### 在线流量，50M

    modify_eipbandwidth_online.sh

### 流量处理模块

    process.sh


