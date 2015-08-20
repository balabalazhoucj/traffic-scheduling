# ucloud-api
本脚本是根据ucloud官方api所编写，处理过程参照官方[python-sdk](https://github.com/ucloud-web/python-sdk-v2)。

每个功能模块对应其命名的shell脚本。

输出结果以json返回。

在centos 6.6调试通过，如有不足欢迎交流。

使用方法：
在同层目录新建一个base.sh文件，在base.sh中，添加如下内容

	#!/bin/sh
	public_key=ucloud账户公钥
	private_key=ucloud账户私钥
