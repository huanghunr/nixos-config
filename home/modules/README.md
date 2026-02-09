## 模块说明

### AI/
AI 工具相关模块集合与包清单。

### Applications/
常用应用与工具模块集合。包含本地应用程序，这些程序不在仓库内，需要自行下载。

### Noctalia/
Noctalia 主题与相关配置。Noctalia配置实现了整个桌面的管理，它统一实现了bar，launch，lock，任务栏图标，dock栏等功能。并且可以把主题注入到特定的程序中，同时支持插件。很好的统一了整个系统的主题。美观易用。

### dev/
开发环境相关模块集合。

### fish.nix
fish Shell 配置与交互体验定制。

### gtk.nix
GTK 主题、字体与外观相关设置。正确设置gtk主题以保证Noctalia的gtk主题可以正常使用。

### hyprland/
Hyprland 桌面环境配置与子模块。

### kitty/
Kitty 终端模拟器配置。设置了kitty终端主题。

### neovim/
Neovim 配置与插件管理。参考文档https://github.com/ryan4yin/nix-config/tree/main/home/base/tui/editors/neovim

### ssh.nix
SSH 客户端配置。

### vscode.nix
VS Code 配置与扩展设置。vscode的插件通过vscode内部下载。background插件无法使用，可以在hyprland中把vscode的背景改为透明，即可看到桌面壁纸使用。

### xdg.nix
XDG 目录与相关规范设置。因为考虑不周，本机刚开始使用的是KDE，所以xdg已经被kde配置，所以没有进行过多配置。这里主要是把本地的程序添加到应用起动器中，或者修改应用起动器中对应应用的启动参数。

### yazi.nix
Yazi 文件管理器配置。

### zellij.nix
Zellij 终端复用器配置。暂时没有使用。
