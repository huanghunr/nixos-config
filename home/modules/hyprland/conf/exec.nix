{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "noctalia-shell &"
      "clipboard_sync &"
    ];
  };
}
