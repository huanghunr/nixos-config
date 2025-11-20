{ config, lib, ... }:

{
  wayland.windowManager.hyprland = {

    settings = {
        windowrulev = [
            "windowrule=pseudo,class:^(fcitx)$"
        ];

      #
      # ===========================
      # WINDOWS & BORDERS (general)
      # ===========================
      #
      general = {
        layout = "dwindle";
        no_focus_fallback = true;

        gaps_in = 5;
        gaps_out = 5;

        border_size = 2;
        "col.active_border" = "0xff4477ff";
        "col.inactive_border" = "0xff2f343f";

        resize_on_border = false;
        hover_icon_on_border = false;

        allow_tearing = false;
      };

      #
      # ==========
      # CURSOR
      # ==========
      #
      cursor = {
        inactive_timeout = 900;
        no_warps = false;
      };

      #
      # ==========
      # ECOSYSTEM
      # ==========
      #
      ecosystem = {
        no_donation_nag = true;
        no_update_news = true;
      };

      #
      # ==========
      # MISC
      # ==========
      #
      misc = {
        focus_on_activate = false;
        disable_hyprland_logo = true;
      };

      #
      # ===========================
      # VISUAL EFFECTS (decoration)
      # ===========================
      #
      decoration = {
        rounding = 8;

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
          new_optimizations = true;
          size = 3;
          passes = 1;
          ignore_opacity = false;
        };
      };

      #
      # ===========================
      # ANIMATIONS
      # ===========================
      #
      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows,          1, 2, myBezier"
          "windowsOut,       1, 2, default, popin 80%"
          "border,           1, 5, default"
          "fadeIn,           1, 2, default"
          "fadeOut,          1, 2, default"
          "workspaces,       1, 6, default, fade"
          "specialWorkspace, 1, 3, myBezier, slide"
        ];
      };

      #
      # ===========================
      # LAYOUT DETAILS
      # ===========================
      #
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_on_top = true;
      };

      #
      # ===========================
      # INPUT DEVICES
      # ===========================
      #
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

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

      #
      # ===========================
      # MONITORS
      # ===========================
      #
      monitor = [
        "HDMI-A-3, preferred, 0x0, 1.5"
        "eDP-1, preferred, 3840x0, 1.25"
      ];
    };
  };
}
