## 一些笔记

### home-manager文件冲突

在运行nixos-build时可能会遇到home manager文件已经存在的冲突用，`journalctl -u home-manager-huanghunr.service -e -n 100` 查看home-manager的日志。

------

### fish function失效问题

fish 的别名最好不要和现有的冲突

------

### 运行旧版electron应用在wayland下

解包后用以下命令运行，需要在本地安装高版本electron以适配wayland。

`electron ./squashfs-root/resources/app.asar --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime`

------

### sha256

`nix-prefetch-url --unpack https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz --type sha256` #获取一个压缩包内容的sha256值

------

### linuxQQ不能复制的问题

`home/script/clipboard_sync.nix` 用于解决linuxQQ不能复制的问题

------

### android-studio avd 启动报错

可以手动启动，android-studio avd 启动参数 `export QT_QPA_PLATFORM=xcb /home/huanghunr/Android/Sdk/emulator/emulator -avd Pixel_6 -netdelay none -netspeed full -gpu swiftshader_indirect`

在android studio内启动需要添加QT_QPA_PLATFORM=xcb环境变量

------

### 更新软件包

`nix flake lock --update-input <name>` 用于更新单个软件包

------

### java

`export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'` Java 字体渲染