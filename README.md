# 🚀 Linux DNS Optimizer

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/language-Bash-green.svg)]()

一个简单、高效的 Linux 服务器 DNS 测速与配置工具。  
专为 **非中国大陆地区** (如 HK, JP, SG, TW, KR, US) 的 VPS 设计，自动测试全球主流高速 DNS 的延迟，并一键替换系统配置。

## ✨ 功能特点

- **⚡ 智能测速**: 自动测试全球主流 DNS 节点延迟，支持 IPv4 和 IPv6。
- **🌏 亚太优化**: 剔除中国大陆 DNS 防止污染，新增 **台湾 (HiNet/Quad101)** 与 **韩国 (KT)** 本地高速节点。
- **🛡️ 广告拦截**: 内置 **AdGuard DNS**，支持一键配置去广告与防跟踪。
- **🔒 配置锁定**: 支持 `chattr +i` 锁定配置文件，防止重启后 DNS 被云厂商 DHCP 强制覆盖。
- **🐧 广泛兼容**: 支持 Debian, Ubuntu, CentOS, AlmaLinux 等主流发行版 (自动适配 `systemd-resolved`)。
- **💾 安全备份**: 修改前自动备份原配置文件，安全无忧。

## 📥 快速使用 (Quick Start)

推荐使用一键脚本（自动下载并运行）：

```bash
bash <(curl -sL https://raw.githubusercontent.com/EmersonLopez2005/Linux-DNS-Optimizer/main/dns.sh)
```
或者手动下载运行：
```
wget https://raw.githubusercontent.com/EmersonLopez2005/Linux-DNS-Optimizer/main/dns.sh
chmod +x dns.sh
sudo ./dns.sh
```
## 📋 收录的 DNS 列表 (DNS List)

本工具精选了 20+ 个全球顶级 DNS 服务商，涵盖 **IPv4 & IPv6**，满足安全、隐私、速度及区域优化的所有需求。

| 🎯 分类 | 🏢 提供商 | 📝 特点说明 |
| :--- | :--- | :--- |
| **🛡️ 安全 & 去广告** | **AdGuard** | **首选推荐**。拦截广告、跟踪器，保护隐私 |
| | **CleanBrowsing** | 专注于拦截恶意软件和钓鱼网站 |
| **🕵️ 极致隐私** | **Mullvad** | 瑞典极客出品，**零日志 (No-Logging)**，匿名性极强 |
| | **DNS.WATCH** | 德国老牌隐私 DNS，适合欧洲 (EU) VPS |
| **⚡ 全球高速** | **Cloudflare** | (1.1.1.1) 全球 Anycast，延迟极低 |
| | **Google** | (8.8.8.8) 全球最流行，稳定可靠 |
| | **Control D** | 新晋速度之王，全球节点覆盖极广 |
| **🏢 企业级/骨干网** | **Level3** | 美国骨干网运营商，**北美 (US) VPS 首选** |
| | **Neustar** | 世界 500 强企业专用，极其稳定 |
| | **OpenDNS** | Cisco 旗下，线路质量极高 |
| **🌏 区域优化** | **HKBN** | **香港** 宽频极速 DNS，HK VPS 推荐 |
| | **HiNet / Quad101** | **台湾** 本地优化，TW VPS 推荐 |
| | **KT DNS** | **韩国** 电信霸主，KR VPS 推荐 |
| | **Yandex** | **俄罗斯** 搜索引擎巨头，RU/CIS 地区推荐 |

> **🚀 特性更新**: v2.0 版本现已**全面支持 IPv6**，上述所有主流厂商的 IPv6 节点均已收录 (包含主/备节点)。

⚠️ 免责声明
本工具仅修改 /etc/resolv.conf 和 /etc/systemd/resolved.conf。虽然脚本包含备份功能，但在生产环境操作前，建议您知晓 DNS 修改可能带来的网络影响。


📄 License
MIT License
<p align="center">
  <a href="https://github.com/EmersonLopez2005/Linux-DNS-Optimizer">
    <img src="https://github-readme-stats.vercel.app/api/pin/?username=EmersonLopez2005&repo=Linux-DNS-Optimizer&theme=nightowl&show_owner=true" alt="GitHub Repo Card">
  </a>
</p>


<p align="center">
  <img src="https://github-profile-trophy.vercel.app/?username=EmersonLopez2005&theme=gitdimmed&no-frame=true&margin-w=4" alt="Trophy">
</p>

