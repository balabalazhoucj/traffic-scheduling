# ucloud-api
本脚本是根据ucloud官方api所编写，处理过程参照官方[python-sdk](https://github.com/ucloud-web/python-sdk-v2)。

每个功能模块对应其命名的shell脚本。

输出结果以json返回。


使用方法：

在同层目录新建一个base.sh文件，在base.sh中，添加如下内容

	#!/bin/sh
	public_key=ucloud账户公钥
	private_key=ucloud账户私钥

#token模块	

    core.sh

#带宽增加模块

    Create_BandwidthPackage.sh

#获取带宽包模块
    
    describe_bandwidthpackage.sh
    
#获取EIP信息模块

    describe_eip.sh

#获取ULB信息模块

    describe_ulb.sh

#获取最近一小时内每150秒流量

    get_metric.sh

#离线流量，10M

    modify_eipbandwidth_offline.sh

#在线流量，50M

    modify_eipbandwidth_online.sh

#流量处理模块

    process.sh