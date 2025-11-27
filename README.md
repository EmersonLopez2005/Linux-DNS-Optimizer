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
## 📋 收录的 DNS 列表

本工具精选了适合国际网络的 DNS 服务商，涵盖 **亚太、北美、欧洲** 等主流 VPS 区域。

| 区域/类型 | 提供商 | 说明 |
| :--- | :--- | :--- |
| **Global** | **Cloudflare** | (1.1.1.1) 全球 Anycast，速度极快，隐私保护 |
| **Global** | **Google** | (8.8.8.8) 全球最流行的 DNS，稳定可靠 |
| **Security** | **AdGuard** | (94.140.14.14) **拦截广告、跟踪器和恶意网站** |
| **US/EU** | **Level3** | (4.2.2.1) **美国** 骨干网 DNS，北美 VPS 首选 |
| **US/EU** | **DNS.WATCH** | (84.200.69.80) **德国** 隐私 DNS，欧洲 VPS 推荐 |
| **Asia** | **HiNet / Quad101** | **台湾** 本地优化，TW VPS 推荐 |
| **Asia** | **KT DNS** | **韩国** 电信霸主，KR VPS 推荐 |

⚠️ 免责声明
本工具仅修改 /etc/resolv.conf 和 /etc/systemd/resolved.conf。虽然脚本包含备份功能，但在生产环境操作前，建议您知晓 DNS 修改可能带来的网络影响。

📄 License
MIT License

