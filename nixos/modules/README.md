## 模块说明

### bluetooth.nix
蓝牙相关服务与设备支持配置。

### docker.nix
Docker 引擎与相关系统设置。

### flatpak.nix
Flatpak 支持与仓库配置。

### frp.nix
FRP 内网穿透客户端/服务相关配置。

### nix-ld.nix
`nix-ld` 兼容层，提升非 Nix 程序运行兼容性。

### nixRuntime.nix
Nix 运行时与系统级通用设置。主要是为了兼容运行程序，steam和steam game配置在这里。

### nvidia.nix
NVIDIA 驱动与图形相关配置。

### podman.nix
Podman 容器运行时配置。和distrobox一起，用于为pwn创建ubuntu环境。

### secrets.nix
机密加载入口（如 SOPS/密钥等）。

### ssh.nix
SSH 服务端配置。

### virtualbox.nix
VirtualBox 虚拟化支持。主要用于运行windows虚拟机，提供windows运行时。
