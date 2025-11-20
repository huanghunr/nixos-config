{ config, lib, ... }:
{
    wayland.windowManager.hyprland.settings = {
        exec-once = [
            "cp ~/.config/fcitx5/profile-bak ~/.config/fcitx5/profile"
            "fcitx5 -d --replace"
            "ln -s \"$XDG_RUNTIME_DIR/hypr\" /tmp/hypr"
            "kitty"
            "clash-verge &"
            "sleep 3"
            "sleep 3"
        ]
    }
}