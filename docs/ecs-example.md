# 个人服务器（阿里云ECS）初始化过程

[TOC]

## 准备工作

该服务器名为`myzoo.cn`，对外地址为`vpn.myzoo.cn`, 通过VPN访问的内网为`myzoo.cn`。

##### 建立服务器配置目录

复制`servers/host.example`为`servers/myzoo.cn`，作为服务器配置目录。此外，因为`vpn.myzoo.cn`也是同一台机器，所以做个软链接`ln -s myzoo.cn vpn.myzoo.cn`链到`myzoo.cn`。

##### SSH登录相关

* 准备个人登录密钥（可以用`ssh-keygen`生成，注意文件权限）
* 修改~/.ssh/config配置该服务器使用密钥登录
```
host myzoo.cn
	user 						root
	PreferredAuthentications 	publickey
	identityfile 				~/private/keys/ssh_key
	
host vpn.myzoo.cn
	user 						root
	PreferredAuthentications 	publickey
	identityfile 				~/private/keys/ssh_key
```

##### OpenVPN配置

在`servers/myzoo.cn/openvpn/`下修改OpenVPN配置文件：

| 文件                      | 说明              | 备注   |
| ----------------------- | --------------- | ---- |
| etc/openvpn/server.conf | OpenVPN服务端配置    |      |
| easy-rsa/vars           | easy-rsa的缺省变量配置 |      |
| client.conf             | OpenVPN客户端配置    |      |

##### hosts.allow/hosts.deny配置

在`servers/myzoo.cn/etc/`下配置`hosts.allow`以及`hosts.deny`配置文件。主要用于仅允许通过VPN的用户访问SSH服务。参考：

hosts.allow
```
sshd:10.9.18.*:allow
```

hosts.deny
```
sshd:all:deny
```

## 部署过程

##### 1.恢复数据盘、系统盘

网页/控制台操作，不赘述。待服务器起来后执行下续步骤。

```
注意：以下操作均在项目根目录进行。
```

##### 2.设置要操作的服务器

步骤可选。这里不设置的话，下面每条命令都要带上要操作的服务器标识（第一个参数）:

```sh
source	_init.sh servers myzoo.cn
```

##### 3.复制登录密钥到服务器

```sh
#清理known_hosts文件中的对应信息【旧服务器标识】
ssh-keygen -R myzoo.cn
#复制登录key到对应服务器，中间会提示接受新服务器标识，以及输入登录密码（应该是最后一次输密码）
./services/sshd/login-key-push 	~/private/keys/ssh_key
```

##### 4.安装必要的软件

```sh
./services/init
```

##### 5.配置OpenVPN服务端

```sh
./services/install	openvpn
```

##### 6.配置OpenVPN客户端

```sh
#生成OpenVPN客户端的key文件，按提示一路修改或直接回车，最后一步输入`y`确认
./services/openvpn/client-key-gen 		client
#备份OpenVPN密钥信息到 servers/myzoo.cn/openvpn/keys/（服务器文件会被清理掉）
./services/openvpn/keys-backup
#生成客户端的VPN文件（servers/myzoo.cn/openvpn/client/）
./services/openvpn/client-conf-build 	client
```

之后，双击生成的`servers/myzoo.cn/_secrets/openvpn/client/vpn.myzoo.cn.ovpn`并输入密码添加到OpenVPN配置中。连接新添加的`vpn.myzoo.cn`配置进行测试，连接成功后直接`ssh myzoo.cn`到服务器内网地址进行测试，没问题的话就应该可以连接到服务器了。

##### 7.更新TCPWarpper配置文件

可选，即更新`hosts.allow`以及`hosts.deny`配置。执行前，务必先开一个ssh连接上去，以防设置有误。
```
./services/etc/tcpwrapper-update		myzoo.cn
```

执行完成后，断开VPN连接，测试自己配置的IP允许／禁止是否生效。

##### 8.更新系统程序包
```
./services/run		myzoo.cn	'yum update -y'
```

## 备注

具体部署过程，可以参考[安装例子](../server/host-example-install)脚本。