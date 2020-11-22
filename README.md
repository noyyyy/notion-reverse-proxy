# 项目介绍

公益非盈利项目, 无任何保证. 
用CN2线路的服务器对Notion进行反向代理, 以加速Notion在中国大陆的访问速度.
原文地址: <https://www.notion.so/jerrywang959/Notion-b39fd3de402e4841a7c2bd64625d1369>

# 使用方法

## 改hosts

host信息

```
119.28.13.121 notion.so
119.28.13.121 www.notion.so
119.28.13.121 msgstore.www.notion.so
```

### Windows 修改 Host

使用工具：[SwitchHosts](https://oldj.github.io/SwitchHosts/) 修改即可。

或者本地搜索 cmd，然后右键以管理员身份打开，接着分别输入以下命令：

```
cd C:\Windows\System32\drivers\etc

notepad hosts
```

将上述 Host 添加进去即可。

又或者使用火绒来修改 Hosts，点击更多工具，选择编辑 Hosts。

### Mac 修改 Host

- 下载 ihost，可以方便帮你配置 Host

# Q&A

## 数据安全

此服务器只进行了流量的代理, 起到中转功能, 并没有储存任何数据.

此服务器只是从tcp层面转发了https流量, 无notion.so的域名证书和私钥, 无法解密流量(不知道传输德是什么内容). 

如果仍然存疑，可以自建

# 捐赠

因为CN2线路很贵, 而且我用的是某里云...本人学生党, 如果你觉得此项目有帮助, 请捐赠, 收入仅仅用于维持服务器成本, 维护人员不会受到任何收入.

<https://afdian.net/@notion-proxy-cn>


