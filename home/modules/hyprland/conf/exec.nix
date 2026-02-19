{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "noctalia-shell &"
      "clash-verge &"
      "clipboard_sync &"
    ];
  };
}
