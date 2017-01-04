# easy-op-centos

一些方便CentOS运维的脚本

[TOC]

## 起因

我有一台部署于[阿里云](https://www.aliyun.com)的ECS服务器，开始作[个人blog](http://blog.jiadan.ren/blog/)用的，后来准备改为服务自己日常开发使用。在重新部署过程中，被一堆命令和细节折腾得很烦，于是产生了将部署操作进行自动化的想法，也就有了这个小项目[easy-op-centos](https://github.com/ximenpo/easy-op-centos)，方便以后CentOS系统的自动化部署。

#### ？为什么不是基于Salt/Ansible...

我有一些Ansible的经验，但算不上熟练。为了尽快把服务器部署起来，我采用了相对更为简单的bash脚本。当然，这不代表以后也会这样。

## 目标

一个*对CentOS/Linux有一些经验*的人，能够很方便地使用该项目提供的脚本，完成CentOS系统的初始化以及一些常用系统的部署。

```
注意：	这里指的是 *对CentOS/Linux有一些经验* 的人，而不是未入门的初学者或高级使用者。这个项目只是为了方便使用，而不是教学或其他。
```

## 环境

* 目标系统：	CentOS6, CentOS7
  * 使用环境：Mac OSX, CentOS6/7

## 目录

本项目目录结构如下：

|    目录    |    子目录     | 说明                          |
| :------: | :--------: | --------------------------- |
| examples |            | 示例文件                        |
|          |  openvpn   | OpenVPN相关配置示例               |
|  files   |            | 操作用到的资源文件、远程脚本等             |
|          | aliyun-ecs | 与阿里云ECS相关的文件                |
| scripts  |            | 本地执行的脚本／命令                  |
|          |    etc     | 与目标etc文件夹有关的脚本              |
|          |  openvpn   | 与OpenVPN有关的脚本               |
|          |    ssh     | 与SSH有关的脚本                   |
|  servers  |            | 私有文件，如服务器配置信息等              |
|          |  myzoo.cn  | myzoo.cn为SSH要连接的目标服务器的SSH名称 |

其中，servers目录下的服务器私有目录结构如下（以myzoo.cn为例）：

|  服务器连接名  |   目录    |  子目录   | 说明                |
| :------: | :-----: | :----: | ----------------- |
| myzoo.cn |         |        | 服务器配置信息           |
|          |   etc   |        | 对应目标服务器etc目录文件    |
|          | openvpn |        | openvpn配置         |
|          |         | client | 客户端配置文件           |
|          |         |  keys  | 对应easy-rsa的keys目录 |

## 功能

### scripts

该目录存放的脚本为常用脚本和使用初始化脚本：

#### _init.centos

功能：	初始化使用环境，安装使用时必要的组件
备注：	第一次使用时执行
示例：	`source scripts/_init.centos.sh`

#### _set-default-host

功能：	设置要缺省的连接服务器，这样调用其他脚本时可以忽略 要连接的服务器
备注：	对服务器要进行多次操作时使用
示例
```
#未设置时执行
./scripts/run	myzoo.cn	echo 'hello~'
#设置默认服务器后执行
source scripts/_set-default-host.sh myzoo.cn
./scripts/run   echo 'hello~'
```

#### run

功能：	在服务器上执行命令
备注：
示例：
```
./scripts/run	myzoo.cn	echo 'hello~'
#或
source  scripts/_set-default-host.sh myzoo.cn
./scripts/run echo 'hello~'
```

#### run-script

功能：	在服务器上执行命令
备注：
示例：
```
./scripts/run-script	myzoo.cn	files/echo-helloworld.sh
#或
source  scripts/_set-default-host.sh myzoo.cn
./scripts/run-script	files/echo-helloworld.sh
```

### scripts/etc

与etc目录配置相关的脚本

#### hosts-update

更新`hosts`文件

#### tcpwrapper-update

更新`hosts.allow`和`hosts.deny`文件

### scripts/openvpn

与OpenVPN相关的脚本

#### client-key-build

生成客户端key文件

#### conf-update

更新OpenVPN配置文件：

| 文件          | 本地位置                                  | 目标位置                       |
| ----------- | ------------------------------------- | -------------------------- |
| server.conf | `servers/myzoo.cn/openvpn/server.conf` | `/etc/openvpn/server.conf` |
| server.conf | `servers/myzoo.cn/openvpn/client.conf` |                            |
| vars        | `servers/myzoo.cn/openvpn/vars`        | `easy-rsa`目录下的`vars`文件     |

#### keys-backup

备份`easy-rsa`的`key`s目录到`servers/myzoo.cn/openvpn/keys`，并清除服务器上的keys目录

#### keys-restore

恢复`servers/myzoo.cn/openvpn/keys`到目标服务器`easy-rsa`的`key`s目录

### scripts/ssh

与SSH相关的脚本

#### copy-id

拷贝指定公钥到目标服务器

### files

可供`run-script`执行的脚本文件

#### install-openvpn.sh

安装OpenVPN系统，执行步骤如下：
1. `./script/run-script myzoo.cn files/install-openvpn.sh`
2. `./script/openvpn/conf-update myzoo.cn`
3. `./script/run-script myzoo.cn files/install-openvpn.sh`

<!-- #### echo-helloworld.sh -->

输出`hello,world~`，供测试用

### files/aliyun-ecs

与阿里云ECS相关的脚本

#### init-data-disk.sh

初始化数据盘，并挂载到`/data`目录，带`noatime,nodiratime`标记
