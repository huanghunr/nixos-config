{ ... }:

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
      "$clipboardManager" = "noctalia-shell ipc call plugin:clipper openPanel";
      "$powerMenu" = "noctalia-shell ipc call sessionMenu toggle";
      "$restartClash" = "pkill clash-verge || true && clash-verge";
      "$restartNoctalia" = "pkill .quickshell-wra || true && noctalia-shell &";
      "$screenshotToclipboard" = "hyprshot -m output --clipboard-only";
      "$screenshotEdit" = "gradia --screenshot";
      "$screenshotFast" = "hyprshot -m region";
      "$desktopManager" = "noctalia-shell &";

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        # "AQ_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1"
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
        inactive_opacity = 1.0;
        fullscreen_opacity = 1.0;
        dim_inactive = true;
        dim_strength = 0.1;

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

        #   bezier = [
        #     "easeOutQuint,   0.23, 1,    0.32, 1"
        #     "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        #     "linear,         0,    0,    1,    1"
        #     "almostLinear,   0.5,  0.5,  0.75, 1"
        #     "quick,          0.15, 0,    0.1,  1"
        #   ];

        #   animation = [
        #     "global,        1,     10,    default"
        #     "border,        1,     5.39,  easeOutQuint"
        #     "windows,       1,     4.79,  easeOutQuint"
        #     "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
        #     "windowsOut,    1,     1.49,  linear,       popin 87%"
        #     "fadeIn,        1,     1.73,  almostLinear"
        #     "fadeOut,       1,     1.46,  almostLinear"
        #     "fade,          1,     3.03,  quick"
        #     "layers,        1,     3.81,  easeOutQuint"
        #     "layersIn,      1,     4,     easeOutQuint, fade"
        #     "layersOut,     1,     1.5,   linear,       fade"
        #     "fadeLayersIn,  1,     1.79,  almostLinear"
        #     "fadeLayersOut, 1,     1.39,  almostLinear"
        #     "workspaces,    1,     1.94,  almostLinear, fade"
        #     "workspacesIn,  1,     1.21,  almostLinear, fade"
        #     "workspacesOut, 1,     1.94,  almostLinear, fade"
        #     "zoomFactor,    1,     7,     quick"
        #   ];

        # end4 theme
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1 # use with .2s duration"
        ];

        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
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

          tap-to-click = true;
          tap-and-drag = true;
        };

        force_no_accel = 0;
        numlock_by_default = 1;
      };
      windowrule = [
        "match:class gimp, no_blur on, no_dim on"
        "opacity 0.8, match:class code"
        "match:class QQ, float yes, max_size 1595 979"
        "match:class wechat, float yes, max_size 1595 979"
        "match:class microsoft-edge, float yes, max_size 1905 1185, center on"
        "match:class com.hex-rays.ida, no_blur on, float yes, no_initial_focus on"
        "match:float on, match:workspace m[0], max_size 1906 1185 "
        "match:float on, match:workspace m[1], max_size 2034 1229 "
        "match:class yesplaymusic, opacity 0.8, float yes, center on,size 1320 880"
        "match:class jetbrains-studio, opacity 0.8"
        "match:class wemeetapp, float yes, no_initial_focus on"
      ];

      monitor = [
        "eDP-2 ,2560x1600@240, 0x0, 1.25"
        "HDMI-A-1, 2560x1440@144, -2560x0, 1"
      ];
    };
  };
}
