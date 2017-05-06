# easy-op-centos

一些方便CentOS6/7运维的脚本

[TOC]

## 起因

我有一台部署于[阿里云](https://www.aliyun.com)的ECS服务器，开始用作[个人blog](http://blog.jiadan.ren/blog/)，后来准备改为服务自己日常开发使用。在重新部署过程中，产生了将部署操作进行自动化的想法，于是也就有了这个小项目[easy-op-centos](https://github.com/ximenpo/easy-op-centos)，方便以后CentOS系统的自动化部署。

#### ？为什么不是基于Salt/Ansible...

我有一些Ansible的经验，但算不上熟练。为了尽快把服务器部署起来，我采用了相对更为简单的bash脚本。当然，以后也许会使用某个框架。

## 目标

对于一个*对CentOS/Linux有一些经验*的人，能够很方便地使用该项目提供的脚本，完成CentOS系统的初始化以及一些常用模块／服务的部署。

```
注意：	这里指的是 *对CentOS/Linux有一些经验* 的人，而不是未入门的初学者或高级使用者。这个项目只是为了方便使用，而不是教学或其他。
```

## 环境

* 目标系统：CentOS6, CentOS7
* 使用环境：Mac OSX, CentOS6/7

## 目录

本项目目录结构如下：

|   目录    |     子目录      | 说明              |
| :-----: | :----------: | --------------- |
|  docs   |              | 相关文档            |
|  files  |              | 操作用到的资源文件、远程脚本等 |
|         |  aliyun-ecs  | 与阿里云ECS相关的文件    |
|         |  openresty   | OpenResty相关的文件  |
| scripts |              | 本地执行的脚本／命令      |
|         |     etc      | 与目标etc文件夹有关的脚本  |
|         |   openvpn    | 与OpenVPN有关的脚本   |
|         |     sshd     | 与SSH有关的脚本       |
|         |     ...      | 其他模块脚本脚本        |
| servers |              | 服务器组群目录（可配置）    |
|         | host.example | 示例服务器名          |

其中，servers目录下的服务器私有目录结构如下（以myzoo.cn为例）：

|    服务器连接名    |    目录    | 子目录  | 说明          |
| :----------: | :------: | :--: | ----------- |
| host.example |          |      | 服务器配置信息     |
|              | \_backup |      | 备份文件所在目录    |
|              | _secrets |      | 密钥等保密文件所在目录 |
|              |   etc    |      | etc目录配置     |
|              |   sshd   |      | sshd服务配置    |
|              | openvpn  |      | openvpn服务配置 |
|              |   ...    |      | 其他服务配置      |

## 功能

### 根目录

根目录只有一个`_init.sh`。

#### _init.sh

初始化本地环境，设置服务器组目录及缺省服务器。

```
Usage:  source _init.sh [default_host] [default_group]
```

### scripts目录

该目录存放的脚本为常用脚本。

#### sync

调用rsync同步文件或目录
```
./services/sync	servers/myzoo.cn/etc/hosts	myzoo.cn:/etc/hosts
```

#### run

在服务器上执行命令
```
./services/run	myzoo.cn	echo 'hello~'
#或使用缺省服务器
./services/run echo 'hello~'
```

#### run-script

在服务器上执行命令
```
./services/run-script	myzoo.cn	files/echo-helloworld.sh
#或使用缺省服务器
./services/run-script	files/echo-helloworld.sh
```

#### install

在服务器上安装指定服务，可带其他参数
```
./services/install	myzoo.cn	openvpn
#或使用缺省服务器
./services/install	openvpn
```

#### reload

在服务器上重启指定服务
```
./services/reload	myzoo.cn	openvpn
#或使用缺省服务器
./services/reload	openvpn
```

#### stop

在服务器上停止指定服务
```
./services/stop		myzoo.cn	openvpn
#或使用缺省服务器
./services/stop		openvpn
```

#### update-conf

更新服务配置
```
./services/update-conf		myzoo.cn	openvpn
#或使用缺省服务器
./services/update-conf		openvpn
```

#### update-conf-and-reload

更新服务配置并重启服务
```
./services/update-conf-and-reload		myzoo.cn	openvpn
#或使用缺省服务器
./services/update-conf-and-reload		openvpn
```

### services/crond

| 脚本          | 功能     | 备注   |
| ----------- | ------ | ---- |
| conf-update | 更新配置文件 |      |
| svc-install | 服务安装脚本 |      |

### services/docker

| 脚本          | 功能     | 备注   |
| ----------- | ------ | ---- |
| conf-update | 更新配置文件 |      |
| svc-install | 服务安装脚本 |      |

### services/etc

与etc目录配置相关的脚本

| 脚本                | 功能                             | 备注   |
| ----------------- | ------------------------------ | ---- |
| hosts-update      | 更新`hosts`文件                    |      |
| tcpwrapper-update | 更新`hosts.allow`和`hosts.deny`文件 |      |

### services/firewalld

| 脚本          | 功能     | 备注   |
| ----------- | ------ | ---- |
| conf-update | 更新配置文件 |      |
| svc-install | 服务安装脚本 |      |

### services/gogs

| 脚本          | 功能            | 备注   |
| ----------- | ------------- | ---- |
| conf-clear  | 清理配置文件，使用默认配置 |      |
| conf-update | 更新配置文件        |      |
| svc-install | 服务安装脚本        |      |

### services/iptables

| 脚本          | 功能     | 备注   |
| ----------- | ------ | ---- |
| conf-update | 更新配置文件 |      |
| svc-install | 服务安装脚本 |      |

### services/ntpd

| 脚本          | 功能     | 备注   |
| ----------- | ------ | ---- |
| conf-update | 更新配置文件 |      |
| svc-install | 服务安装脚本 |      |

### services/openresty

| 脚本          | 功能     | 备注   |
| ----------- | ------ | ---- |
| conf-update | 更新配置文件 |      |
| svc-install | 服务安装脚本 |      |

### services/php-fpm

| 脚本           | 功能              | 备注   |
| ------------ | --------------- | ---- |
| conf-update  | 更新配置文件          |      |
| pkg-clear    | 删除所有php开头的包     |      |
| pkg-install  | 使用webtatic库安装包  |      |
| repo-install | 安装webtatic的yum库 |      |
| svc-install  | 服务安装脚本          |      |

### services/openvpn

与OpenVPN服务相关的脚本

| 脚本               | 功能                                       | 备注   |
| ---------------- | ---------------------------------------- | ---- |
| client-key-build | 生成客户端ovpn登录配置文件，位于`_secrets/openvpn/client`目录 |      |
| client-key-gen   | 生成指定客户的密钥                                |      |
| conf-update      | 更新OpenVPN配置文件                            |      |
| keys-backup      | 备份`easy-rsa`的`keys`目录到`_secrets/openvpn/keys`，<br>并清除服务器上的keys目录 |      |
| keys-restore     | 恢复备份的`_secrets/openvpn/keys`到目标服务器`easy-rsa`的`keys`目录 |      |
| svc-install      | 服务安装脚本                                   |      |
| svc-reload       | 服务重启脚本                                   |      |
| svc-stop         | 服务关闭脚本                                   |      |

### services/sshd

与sshd服务配置相关的脚本

| 脚本             | 功能            | 备注   |
| -------------- | ------------- | ---- |
| conf-update    | 更新配置文件        |      |
| login-key-push | 推送登录密钥的公钥到服务器 |      |
