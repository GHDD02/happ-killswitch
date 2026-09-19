# 🛡️ Happ Bulletproof Kill Switch & Identity Shield

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Linux](https://img.shields.io/badge/Platform-Linux-orange.svg)](#)
[![nftables](https://img.shields.io/badge/Firewall-nftables-crimson.svg)](#)
[![Privacy](https://img.shields.io/badge/Privacy-100%25%20Shielded-success.svg)](#)

A high-performance, leak-proof **Kill Switch** and **Automated Identity & Geolocation Spoofing Engine** for Linux systems using the **Happ VPN** client (`sing-box` TUN / `xray`).

---

## 🌟 Key Features

* 🔒 **Zero-Drop nftables Engine**:
  * Prevents connection drops caused by unprivileged `xray` processes by authorizing proxy cores through a dedicated system GID (`happvpn`).
  * 100% fail-closed policy: If the VPN tunnel drops or disconnects, **not a single packet** can escape the physical network interface.
* 🚀 **Multi-Browser Privacy Hardening**:
  * **Google Chrome, Chromium, Brave, Microsoft Edge**: Applies managed enterprise policies (`WebRtcIPHandlingPolicy: disable_non_proxied_udp`) to completely eliminate WebRTC STUN leaks (both local private IP and real public IP).
  * **Mozilla Firefox**: Enforces strict ICE interface selection and disables telemetry/geo network requests.
* 📍 **GeoClue2 GPS Mocking (Anti Wi-Fi BSSID Tracking)**:
  * Disables Wi-Fi BSSID access point triangulation (`[wifi] enable=false`) in GeoClue.
  * Injects static spoofed GPS coordinates matching your active VPN endpoint city.
* ⏰ **Real-Time Timezone Synchronization**:
  * Eliminates browser timezone fingerprinting mismatches (`Intl.DateTimeFormat().resolvedOptions().timeZone`) by synchronizing system time via `timedatectl`.
* 👤 **Realistic Persona & Address Generator**:
  * Generates localized physical addresses (street name, house number, postal code, city) and personas for 20+ countries.
* 👁️ **Background Watcher Mode (Daemon)**:
  * Automatically monitors VPN IP changes and instantly re-synchronizes timezone and mock coordinates when you switch servers in Happ.

---

## 📋 System Requirements

* **OS**: Linux (Ubuntu, Debian, Fedora, Arch, etc.) with `systemd`
* **Firewall**: `nftables`
* **Dependencies**: `python3`, `curl`, `iproute2` (standard on all modern distributions)

---

## ⚡ Quick Installation

### Option 1: One-Line Installer
```bash
curl -fsSL https://raw.githubusercontent.com/sunatillo-muratov/happ-killswitch/main/install.sh | sudo bash
```

### Option 2: Clone & Install
```bash
git clone https://github.com/sunatillo-muratov/happ-killswitch.git
cd happ-killswitch
sudo ./happ-killswitch install
```

---

## 📖 Usage & Commands

```bash
# Enable Kill Switch, browser shields, and spoof identity
sudo happ-killswitch on

# Check current status, public IP, and spoofed persona
happ-killswitch status

# Re-sync timezone, GPS coords, and fake address (e.g. after switching servers)
sudo happ-killswitch spoof

# Refresh firewall whitelist and re-sync geo profile
sudo happ-killswitch refresh

# Start background watcher daemon (auto-updates on IP change)
sudo happ-killswitch watch

# Allow local network access (printers, NAS, local router 192.168.x.x)
sudo happ-killswitch lan-on

# Block local network access (100% strict VPN tunnel)
sudo happ-killswitch lan-off

# Disable Kill Switch and restore unconstrained network
sudo happ-killswitch off

# Uninstall everything cleanly
sudo happ-killswitch uninstall
```

---

## 🖥️ Status Output Example

```text
==================== [ HAPP KILL SWITCH STATUS ] ====================
🔒  Kill Switch:         [ ACTIVE - 100% ISOLATION ]
⚙️   Autostart:           enabled
🛡️   Browser Protection:  Active (Chrome, Brave, Edge, Firefox hardened)
📍  GeoClue2 GPS Mock:   Active (Static GPS: 52.3740 4.8897 )

====================================================================
🛡️   HAPP BULLETPROOF KILL SWITCH & IDENTITY SHIELD: ACTIVE
====================================================================
🔒  Network Isolation:  100% SHIELDED (all non-VPN packets dropped)
🌐  Public VPN IP:      67.213.127.217 (Latitude.sh LTDA)
📍  GeoIP Location:     Amsterdam, North Holland (Netherlands)
⏰  System Timezone:    Europe/Amsterdam (Synchronized via timedatectl)
🌍  Mock GPS Coords:    52.3740° N, 4.8897° E (GeoClue2 active)
🏠  Spoofed Address:    Keizersgracht 114, 1012 ER Amsterdam, Netherlands
👤  Spoofed Persona:    Lars van Dijk <lars.vandijk54@gmail.com>
🚀  Browser Shields:    WebRTC STUN & Wi-Fi Scanning BLOCKED
====================================================================
```

---

## 🔍 Architecture & How It Works

```
                     ┌──────────────────────────────┐
                     │   User Applications (Apps)   │
                     │  (Chrome, Telegram, cURL...) │
                     └──────────────┬───────────────┘
                                    │ (Outbound traffic)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                        NFTABLES FILTER (happkill)                      │
│                                                                        │
│  [1] Output to lo / tun0 / happ-xray?    ─────────► ACCEPT             │
│  [2] Has socket GID "happvpn" (xray)?    ─────────► ACCEPT (Physical)  │
│  [3] Inside cgroup happd.service?        ─────────► ACCEPT (Physical)  │
│  [4] Any other physical output?          ─────────► DROP (Zero-Leak)   │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Why standard Kill Switches fail in Happ**:
   Happ runs the root TUN daemon (`happd`), but spawns the outbound proxy core (`xray`) inside the desktop user session. Standard cgroup-only rules block `xray` from communicating with the remote server. Happ Shield solves this using `setgid` authorization on proxy binaries, creating a fail-proof pipeline.
2. **Anti-Leak Defense in Depth**:
   * **WebRTC**: Forced to `disable_non_proxied_udp` via system policy files.
   * **Wi-Fi Triangulation**: GeoClue Wi-Fi scans are disabled at the system level.
   * **DNS**: System DNS is locked to prevent plaintext leaks.
   * **IPv6**: Instantly rejected to eliminate fallback timeouts.

---

## 🇷🇺 Документация на русском языке

### Особенности
* **Защита от утечек 100%**: блокировка всего трафика мимо туннеля VPN на уровне ядра `nftables`.
* **Исправление падений сети**: устранена ошибка блокировки ядра `xray`, работающего в пользовательской сессии.
* **Защита Google Chrome, Brave, Edge, Firefox**: отключение утечек реального IP через WebRTC STUN и запрет триангуляции по Wi-Fi роутерам.
* **Спуфинг геолокации и времени**: синхронизация системного часового пояса и координат GPS (через GeoClue2) под страну текущего сервера.
* **Генератор адреса и личности**: автоматическое создание правдоподобного физического адреса и профиля в стране подключения.

### Быстрый старт
```bash
sudo ./happ-killswitch install
sudo happ-killswitch on
happ-killswitch status
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
