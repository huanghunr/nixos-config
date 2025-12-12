## 一些笔记

`journalctl -u home-manager-huanghunr.service -e -n 100` 查看home-manager的日志

fish 的别名最好不要和现有的冲突

`electron ./squashfs-root/resources/app.asar --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime`

`nix-prefetch-url --unpack https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz --type sha256` #获取一个压缩包内容的sha256值

`./home/script/clipboard_sync.nix` 用于解决linuxQQ不能复制的问题


android-studio avd 启动参数 `export QT_QPA_PLATFORM=xcb /home/huanghunr/Android/Sdk/emulator/emulator -avd Pixel_6 -netdelay none -netspeed full -gpu swiftshader_indirect`