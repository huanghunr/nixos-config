{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "clash-verge &"
      "noctalia-shell &"
      "clipboard_sync &"
    ];
  };
}
