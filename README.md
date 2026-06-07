# 项目介绍

公益非盈利项目, 无任何保证.

用CN2线路的服务器对 Notion 进行反向代理, 以加速 Notion 在中国大陆的访问速度.

阅读更多: <https://notionfaster.org>

# 使用方法

## 改 hosts

默认推荐使用当前 Notion 域名（`.com` / `notionusercontent.com`）。将以下内容加入本机 hosts：

```hosts
119.28.13.121 app.notion.com
119.28.13.121 img.notionusercontent.com
119.28.13.121 msgstore-002.app.notion.com
119.28.13.121 identity.notion.com
119.28.13.121 exp.notion.com
119.28.13.121 audioprocessor.app.notion.com
```

### Windows 修改 Host

使用工具：[SwitchHosts](https://oldj.github.io/SwitchHosts/) 修改即可。

或者本地搜索 cmd，然后右键以管理员身份打开，接着分别输入以下命令：

```
cd C:\Windows\System32\drivers\etc

notepad hosts
```

将以上 Host 添加进去即可。

又或者使用火绒来修改 Hosts，点击更多工具，选择编辑 Hosts。

### Mac 修改 Host

- 下载 ihost，可以方便帮你配置 Host

## 兼容旧版域名

如果你的旧客户端、旧脚本或旧 hosts 仍在使用 `.so` 域名，可以继续保留以下映射：

```hosts
119.28.13.121 www.notion.so
119.28.13.121 notion.so
119.28.13.121 msgstore.www.notion.so
119.28.13.121 exp.notion.so
119.28.13.121 api.pgncs.notion.so
119.28.13.121 audioprocessor.www.notion.so
```

新部署优先使用上面的新域名配置（`.com` / `notionusercontent.com`）。

# 如何部署服务端

纯净 ubuntu 20.04, debian 10. 以 root 权限运行

```shell
apt install curl
bash <(curl -Lso- https://raw.githubusercontent.com/Jerrywang959/notion-reverse-proxy/main/install.sh)
```

更新配置
```shell
bash <(curl -Lso- https://raw.githubusercontent.com/noyyyy/notion-reverse-proxy/dev/update.sh)
```

## 测试是否反代成功

使用 curl, curl 的 `--resolve` 参数可以强指 IP：

```bash
curl https://app.notion.com --resolve app.notion.com:443:119.28.13.121
```

# 捐赠

如果你觉得此项目有帮助, 请捐赠, 收入仅仅用于维持服务器成本, 维护人员不会受到任何收入.

<https://afdian.net/@notion-proxy-cn>
