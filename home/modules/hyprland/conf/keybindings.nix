{ config, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {

    # ================================================================
    # mouse binds
    # ================================================================
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    # ================================================================
    # main binds
    # ================================================================
    bind = [

      # ===================== SYSTEM =====================
      "$mod, q, killactive,"
      "$mod, Return, exec, kitty"
      "$mod SHIFT, Return, exec, fish"
      "$mod, d, exec, anyrun"

      # hardware
      ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86Search, exec, anyrun"

      # ===================== WORKSPACE SWITCH =====================
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # ===================== MOVE TO WORKSPACE =====================
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # mouse scroll workspace
      "$mod, mouse_down, workspace, e+1"
      "$mod, mouse_up, workspace, e-1"

      # ===================== WINDOW MOVE =====================
      "$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"

      # ===================== WINDOW FOCUS =====================
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      # ===================== WINDOW RESIZE =====================
      "$mod CTRL, left, resizeactive, -20 0"
      "$mod CTRL, right, resizeactive, 20 0"
      "$mod CTRL, up, resizeactive, 0 -20"
      "$mod CTRL, down, resizeactive, 0 20"

      # ===================== MODES =====================
      "$mod SHIFT, d, submap, mode_displays"
      "$mod SHIFT, a, submap, mode_move"
      "$mod, r, submap, mode_resize"
      "$mod SHIFT, s, submap, mode_screenshot"
      "$mod SHIFT, e, submap, mode_shutdown"

      # ===================== LAYOUT =====================
      "$mod, space, togglefloating"
      "$mod, f, fullscreen"

      # ===================== SCREENSHOTS =====================
      ", Print, exec, hyprshot -m output -o ~/Pictures/Screenshots -- imv"
      "$mod, Print, exec, hyprshot -m window -o ~/Pictures/Screenshots -- imv"
      "CTRL, Print, exec, hyprshot -m region -o ~/Pictures/Screenshots"

      # ===================== MISC =====================
      "CTRL ALT, l, exec, swaylock"
      "$mod SHIFT, x, exec, wlogout"
      "ALT, E, exec, pkill fcitx5 -9"
    ];

    # ================================================================
    # bindl: non-exclusive repeating keys (volume/mute)
    # ================================================================
    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    # ================================================================
    # bindle: element-wise keyrepeat actions
    # ================================================================
    bindle = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];

    # ================================================================
    # gestures
    # ================================================================
    gesture = [
      "3, horizontal, workspace"
      "3, down, mod: ALT, close"
      "3, up, mod: SUPER, scale: 1.5, fullscreen"
    ];
  };
}
