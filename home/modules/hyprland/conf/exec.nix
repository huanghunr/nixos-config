{ config, lib, ... }:
{
    wayland.windowManager.hyprland.settings = {
        exec-once = [
            "kitty"
            "clash-verge &"
            "waybar &"
            "mako &"
        ];
    };
}