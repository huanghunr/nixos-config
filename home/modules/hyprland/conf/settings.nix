{ config, lib, ... }:

{
  wayland.windowManager.hyprland = {
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "noctalia-shell ipc call launcher toggle";
      "$browser" = "microsoft-edge";
      "$codeEditor" = "code";
      "$controlCenter" = "noctalia-shell ipc call controlCenter toggle";
      "$settingsManager" = "noctalia-shell ipc call settings toggle";
      "$lockScreen" = "noctalia-shell ipc call lockScreen lock";
      "$clipboardManager" = "noctalia-shell ipc call launcher clipboard";
      "$powerMenu" = "noctalia-shell ipc call sessionMenu toggle";
      "$restartClash" = "pkill clash-verge || true && clash-verge";
      "$restartNoctalia" = "pkill noctalia-shell || true && noctalia-shell &";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      windowrule = [
        "pseudo, class:^(fcitx)$"
      ];

      general = {
        layout = "dwindle";
        no_focus_fallback = true;

        gaps_in = 5;
        gaps_out = 5;

        border_size = 2;
        "col.active_border" = "0xfff4cccc";
        "col.inactive_border" = "0xff2f343f";

        resize_on_border = false;
        hover_icon_on_border = false;

        allow_tearing = false;
      };

      cursor = {
        inactive_timeout = 900;
        no_warps = false;
      };

      ecosystem = {
        no_donation_nag = true;
        no_update_news = true;
      };

      misc = {
        focus_on_activate = false;
        disable_hyprland_logo = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        active_opacity = 1.0;
        inactive_opacity = 0.9;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          new_optimizations = false;
          size = 3;
          passes = 1;
          ignore_opacity = false;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,   0.23, 1,    0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear,         0,    0,    1,    1"
          "almostLinear,   0.5,  0.5,  0.75, 1"
          "quick,          0.15, 0,    0.1,  1"
        ];

        animation = [
          "global,        1,     10,    default"
          "border,        1,     5.39,  easeOutQuint"
          "windows,       1,     4.79,  easeOutQuint"
          "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
          "windowsOut,    1,     1.49,  linear,       popin 87%"
          "fadeIn,        1,     1.73,  almostLinear"
          "fadeOut,       1,     1.46,  almostLinear"
          "fade,          1,     3.03,  quick"
          "layers,        1,     3.81,  easeOutQuint"
          "layersIn,      1,     4,     easeOutQuint, fade"
          "layersOut,     1,     1.5,   linear,       fade"
          "fadeLayersIn,  1,     1.79,  almostLinear"
          "fadeLayersOut, 1,     1.39,  almostLinear"
          "workspaces,    1,     1.94,  almostLinear, fade"
          "workspacesIn,  1,     1.21,  almostLinear, fade"
          "workspacesOut, 1,     1.94,  almostLinear, fade"
          "zoomFactor,    1,     7,     quick"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        accel_profile = "flat";

        follow_mouse = 1;
        mouse_refocus = false;

        natural_scroll = 0;

        touchpad = {
          natural_scroll = 1;
          clickfinger_behavior = true;
          disable_while_typing = true;

          tap-to-click = false;
          tap-and-drag = false;
        };

        force_no_accel = 0;
        numlock_by_default = 1;
      };

      monitor = [
        "eDP-2 ,2560x1600@240, 0x0, 1.25"
        "HDMI-A-1, 3840x2160@60, -2560x0, 1.5"
      ];
    };
  };
}
