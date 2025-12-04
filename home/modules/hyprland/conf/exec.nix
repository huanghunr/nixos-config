{ config, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "clash-verge &"
      "noctalia-shell &"
    ];
  };
}
