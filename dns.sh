#!/bin/bash
# ====================================================
# Project: Linux DNS Optimizer
# Description: Smart script to benchmark & switch to the fastest DNS
# Source: https://github.com/YourUsername/Linux-DNS-Optimizer
# License: MIT
# ====================================================

# 颜色定义
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
RESET='\033[0m'

# 检查 Root 权限
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}[!] 错误：此脚本必须以 root 权限运行。${RESET}"
    echo -e "请使用: sudo bash $0"
    exit 1
fi

# ====================================================
# DNS 列表配置 (格式: IP|说明)
# ====================================================
DNS_LIST=(
    # --- 安全与去广告 (Security & AdBlock) ---
    "94.140.14.14|AdGuard DNS (Default - AdBlock)"
    "94.140.15.15|AdGuard DNS (Family Protection)"
    "1.1.1.2|Cloudflare (Malware Blocking)"
    "9.9.9.9|Quad9 (Malware Blocking)"

    # --- 泛亚太/全球高速 (Global Anycast - 推荐 HK/JP/SG) ---
    "1.1.1.1|Cloudflare (IPv4)"
    "8.8.8.8|Google Public DNS (IPv4)"
    "208.67.222.222|OpenDNS (IPv4)"
    "1.0.0.1|Cloudflare Secondary"
    "8.8.4.4|Google Secondary"
    
    # --- 地区特色优化 (Regional - TW/KR) ---
    "101.101.101.101|Quad101 (Taiwan - TWNIC)"
    "168.95.1.1|HiNet (Taiwan Telecom)"
    "168.126.63.1|KT DNS (South Korea)"
    
    # --- IPv6 ---
    "2606:4700:4700::1111|Cloudflare (IPv6)"
    "2001:4860:4860::8888|Google (IPv6)"
    "2a10:50c0::ad1:ff|AdGuard (IPv6)"
    "2001:b000:168::1|HiNet (Taiwan IPv6)"
)

# ====================================================
# 核心功能函数
# ====================================================

test_dns_speed() {
    clear
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${BLUE}       🚀 Linux DNS Optimizer           ${RESET}"
    echo -e "${BLUE}   (测速 + 优选 + 自动配置 + AdGuard)   ${RESET}"
    echo -e "${BLUE}========================================${RESET}"
    echo -e "${CYAN}>>> 正在测试 DNS 延迟 (Ping), 请稍候...${RESET}\n"
    
    declare -a results
    
    for item in "${DNS_LIST[@]}"; do
        IFS='|' read -r ip name <<< "$item"
        
        # 判断 IPv4 还是 IPv6 并检查连通性
        ping_cmd="ping"
        if [[ "$ip" == *":"* ]]; then
            ping_cmd="ping6"
            if ! command -v ping6 &>/dev/null && ! ping -6 -c 1 ::1 &>/dev/null; then continue; fi
        fi
        
        printf "  %-42s (%-15s) ... " "${name}" "${ip}"
        
        # 测速逻辑：发包2次，超时1秒，取平均值
        latency=$(LC_ALL=C $ping_cmd -c 2 -W 1 "$ip" 2>/dev/null | grep 'avg' | awk -F'/' '{print $5}')
        
        if [ -n "$latency" ]; then
            echo -e "${GREEN}${latency} ms${RESET}"
            results+=("$latency|$ip|$name")
        else
            echo -e "${RED}超时${RESET}"
            results+=("9999|$ip|$name")
        fi
    done

    # 排序结果
    IFS=$'\n' sorted=($(printf "%s\n" "${results[@]}" | sort -n -t'|' -k1))
    unset IFS

    echo -e "\n${CYAN}>>> 🏆 延迟最低 Top 10:${RESET}"
    echo -e "${YELLOW}------------------------------------------------------------${RESET}"
    
    top_ips=()
    count=0
    valid_options=()
    
    for item in "${sorted[@]}"; do
        IFS='|' read -r lat ip name <<< "$item"
        if [ "$lat" != "9999" ] && [ $count -lt 10 ]; then
            idx=$((count+1))
            printf "  ${GREEN}%-2d${RESET}. %-32s ${YELLOW}%-18s${RESET} -> ${CYAN}%s ms${RESET}\n" "$idx" "$name" "($ip)" "$lat"
            top_ips+=("$ip")
            valid_options[$idx]="$ip"
            count=$((count+1))
        fi
    done
    echo -e "${YELLOW}------------------------------------------------------------${RESET}"
    
    if [ $count -eq 0 ]; then
        echo -e "${RED}错误：所有 DNS 均无法连接，请检查服务器网络。${RESET}"
        exit 1
    fi
}

apply_config() {
    echo -e "\n${BLUE}请选择要使用的 DNS:${RESET}"
    echo -e "  [1-10] 输入序号选择 (支持多选，用空格分隔，如: 1 2)"
    echo -e "  [c]    自定义输入 IP"
    echo -e "  [0]    退出不保存"
    echo -ne "\n${YELLOW}请输入: ${RESET}"
    read -r choice

    selected_dns=""

    if [ "$choice" == "0" ]; then
        echo "已退出。"
        exit 0
    elif [ "$choice" == "c" ]; then
        read -p "请输入自定义 DNS IP (空格分隔): " custom_ips
        selected_dns="$custom_ips"
    else
        for c in $choice; do
            if [ -n "${valid_options[$c]}" ]; then
                selected_dns="$selected_dns ${valid_options[$c]}"
            fi
        done
    fi

    if [ -z "$selected_dns" ]; then
        echo -e "${RED}未选择有效的 DNS，操作已取消。${RESET}"
        exit 1
    fi
    
    # 去重
    selected_dns=$(echo "$selected_dns" | tr ' ' '\n' | awk '!a[$0]++' | tr '\n' ' ')

    echo -e "\n${CYAN}>>> 正在应用配置: $selected_dns ...${RESET}"

    # 1. 解锁
    if lsattr /etc/resolv.conf 2>/dev/null | grep -q "i"; then
        chattr -i /etc/resolv.conf
    fi

    # 2. 备份
    cp /etc/resolv.conf "/etc/resolv.conf.bak.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}[√] 已备份原配置${RESET}"

    # 3. 写入 /etc/resolv.conf
    echo "# Generated by Linux-DNS-Optimizer" > /etc/resolv.conf
    for ip in $selected_dns; do
        echo "nameserver $ip" >> /etc/resolv.conf
    done

    # 4. 适配 systemd-resolved
    if systemctl is-active systemd-resolved &>/dev/null; then
        sed -i '/^DNS=/d' /etc/systemd/resolved.conf
        echo "DNS=$selected_dns" >> /etc/systemd/resolved.conf
        systemctl restart systemd-resolved
        echo -e "${GREEN}[√] systemd-resolved 配置已同步${RESET}"
    fi

    # 5. 锁定文件
    echo -e "\n${YELLOW}是否锁定配置文件？(防止重启后失效) [Y/n]${RESET}"
    read -r lock_choice
    if [[ "$lock_choice" =~ ^[Nn]$ ]]; then
        echo -e "${GREEN}[√] 配置完成 (未锁定)${RESET}"
    else
        chattr +i /etc/resolv.conf
        echo -e "${GREEN}[√] 配置完成 (文件已锁定 +i)${RESET}"
    fi
}

test_dns_speed
apply_config
