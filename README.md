# Folia Music 一键部署指南

> 第三方部署指南 · 非 Folia Music 官方仓库。官方项目：[chthollyphile/folia-major](https://github.com/chthollyphile/folia-major)
> 内容来自官方文档（2026-11-02）。项目迭代快，请以[官方文档](https://github.com/chthollyphile/folia-major/blob/main/deploy/docker/README.md)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 歌词不该只是底部两行字：全屏、逐字、跟着情绪走，才是这张唱片该有的样子。

⚠️ 需要 Docker Engine 24+ 与 Compose v2。Compose 会拉起网关、Web API、网易云/酷狗/QQ 音源与独立 Sync Server 共五个镜像，默认 Web 端口 18080、Sync 端口 13000。`SYNC_TOKEN` 必填且至少八位。官方镜像在 Docker Hub 的 `papersman` 命名空间，国内拉取可能较慢。本地音乐目录访问要求可信 HTTPS 上下文，NAS 需配反向代理与证书。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/folia-music-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会下载 compose 与 env 模板，生成同步令牌，再拉起网关、后端、音源与同步服务，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://localhost:18080](http://localhost:18080)，按官方引导完成初始化配置。

## Folia Music 是什么？

Folia Music 是开源的把音乐播放器做成一场全屏歌词演出：本地库、Navidrome 与在线音源都能接（协议：AGPL-3.0，<img src="https://img.shields.io/github/stars/chthollyphile/folia-major?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

以全屏沉浸式歌词为核心的音乐播放器：搜索并播放网易云、酷狗、QQ 音乐，接入本地音乐库与 Navidrome，智能匹配歌词与封面，用 AI 生成配色主题，并提供多种可调的歌词动画。

- 全屏歌词动画：浮名、流光、群唱等十余种主题
- 多音源：网易云、酷狗、QQ、Navidrome 与本地库
- 智能匹配：自动补歌词与封面，可手动修正
- 本地优先：音频不上传，索引留在自己机器
- 桌面 + Web：Electron 安装包或 Docker 自托管
- 跨设备同步：可选 Sync Server 同步外观与主题

（来源：[官方仓库](https://github.com/chthollyphile/folia-major)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 11173 stars | 歌词动画类播放器里的头部项目 |
| 全屏歌词主题多 | 参数可调 |
| 本地库、Navidrome 与三家在线音源都能接 | — |
| Docker 一条 compose 起完整 Web 栈 | — |
| 桌面端另有 Electron 安装包 | — |
| 可选 Sync Server 跨设备同步 | — |

| 需要注意 | 说明 |
|---|---|
| 五个镜像 | 资源占用不低 |
| 国内拉取 Docker Hub 镜像可能慢 | — |
| 本地音乐目录要 HTTPS 才能访问 | — |
| AGPL-3.0 | 商用需注意 |
| 在线音源依赖第三方接口 | 可能变化 |

> 以上基于官方文档与社区反馈整理（2026-11-02），以官方最新文档为准。

## 快速部署（官方方式）

```bash
mkdir folia-docker && cd folia-docker
curl -fL https://raw.githubusercontent.com/chthollyphile/folia-major/main/deploy/docker/compose.yaml -o compose.yaml
curl -fL https://raw.githubusercontent.com/chthollyphile/folia-major/main/deploy/docker/.env.example -o .env
sed -i "s/^SYNC_TOKEN=.*/SYNC_TOKEN=$(openssl rand -hex 32)/" .env
docker compose pull
docker compose up -d --wait
echo "已启动：Web 在 http://localhost:18080"
```

启动后浏览器访问 [http://localhost:18080](http://localhost:18080)（管理面板）。（来源：[https://github.com/chthollyphile/folia-major/blob/main/deploy/docker/README.md](https://github.com/chthollyphile/folia-major/blob/main/deploy/docker/README.md)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 与 Docker 文档确认 compose 方式、18080/13000 端口与 SYNC_TOKEN 要求 | 已核对 2026-11-02 |
| 确认五个镜像、papersman 命名空间与本地音乐需 HTTPS | 已核对 2026-11-02 |
| 未实测拉取镜像与启动 | 说明 2026-11-02 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-02 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-02 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、端口、环境变量与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-02）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\folia-music-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 部署前先准备

| 项目 | 要求 |
|---|---|
| Docker | Engine 24+、Compose v2 |
| 端口 | Web `18080`、Sync `13000` |
| 必填 | `SYNC_TOKEN`，至少八位 |
| 镜像 | 默认命名空间 `papersman` |
| HTTPS | 访问本地音乐目录需要可信 HTTPS |

只需要两个文件：`compose.yaml` 与 `.env`，不用克隆整个仓库。

## 启动后

1. 打开 `http://NAS-IP:18080`
2. 在设置里连接音乐源或导入本地库
3. 需要跨设备同步时，填 Sync Server 地址与 `SYNC_TOKEN`
4. AI 主题可选，留空不影响播放

## 常用环境变量

| 变量 | 默认 | 作用 |
|---|---|---|
| `FOLIA_HTTP_PORT` | `18080` | Web 网关端口 |
| `FOLIA_SYNC_PORT` | `13000` | Sync Server 端口 |
| `FOLIA_IMAGE_NAMESPACE` | `papersman` | 镜像命名空间 |
| `SYNC_TOKEN` | 无 | 同步客户端令牌，必填 |
| `NAVIDROME_URL` 等 | 空 | 三项都填可预置 Navidrome 登录 |
| `FOLIA_AI_PROVIDER` | `google` | 主题生成用哪家模型 |

## 国内网络

- 镜像拉取慢时给 Docker 配镜像加速，或改 `FOLIA_IMAGE_NAMESPACE` 指向自己的镜像仓库
- 桌面版安装包可从 Releases 或网盘获取

## 注意

- `SYNC_TOKEN` 少于八位会拒绝启动
- 网易云、酷狗、QQ 与 Web API 不暴露宿主端口，只能经网关访问
- 反向代理要透传真实 IP 并配置证书，否则本地音乐目录无法读取
- AI 主题与在线音源都需要外网
- AGPL-3.0，二次分发与商用前先读许可证

## 常见坑

- compose 起不来：确认 `SYNC_TOKEN` 已填且不少于八位
- 18080 打不开：等 `docker compose up -d --wait` 全部 healthy
- 镜像拉取失败：配置镜像加速，或改 `FOLIA_IMAGE_NAMESPACE`
- 本地音乐读不到：用 HTTPS 域名访问，别直接走 HTTP 的内网 IP
- 登录地点显示局域网：保持 `FOLIA_FORWARD_CLIENT_IP=false`
- 同步连不上：确认 13000 端口可达且 Token 与客户端一致
- 反向代理后来源 IP 不对：设置 `FOLIA_TRUSTED_PROXIES`
- 更新后异常：先 `docker compose pull` 再 `up -d`，别混用旧镜像

## 免责声明

本仓库为第三方指南，与 Folia Music 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-02），项目迭代快，请以[官方文档](https://github.com/chthollyphile/folia-major/blob/main/deploy/docker/README.md)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
