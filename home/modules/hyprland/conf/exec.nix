{ config, lib, ... }:
{
    wayland.windowManager.hyprland.settings = {
        exec-once = [
            "zellij &"
            "clash-verge &"
            "waybar &"
            "microsoft-edge &"
        ];
    };
}