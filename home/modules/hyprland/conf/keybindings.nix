{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      "SUPER_SHIFT, Return, exec, $terminal"
      "SUPER, Return, exec, [float on;size 1480 870;center on;] $terminal"
      "SUPER, C, killactive,"
      "SUPER, M, exit,"
      "SUPER, Escape, exec, $powerMenu"
      "SUPER, L, exec, $lockScreen"
      "SUPER, R, exec, $fileManager"
      "SUPER, V, exec, $clipboardManager"
      "SUPER, G, exec, $controlCenter"
      "SUPER, T, exec, $settingsManager"
      "SUPER, I, exec, $codeEditor"
      "SUPER, N, exec, $restartNoctalia"
      "SUPER_SHIFT, F, exec, $screenshotFast"
      "SUPER_SHIFT, C, exec, $screenshotToclipboard"
      "SUPER_SHIFT, E, exec, $screenshotEdit"
      "SUPER, L, exec, $desktopManager"
      "SUPER, Y, exec, yazi"
      "SUPER, F, togglefloating,"
      "SUPER, E, exec, $menu"
      "SUPER, F1, exec, $restartClash"
      "SUPER, P, pseudo, # dwindle"
      "SUPER, J, togglesplit, # dwindle"
      "SUPER, B, exec, $browser"
      "SUPER, left, movefocus, l"
      "SUPER, right, movefocus, r"
      "SUPER, up, movefocus, u"
      "SUPER, down, movefocus, d"
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"
      "SUPER_SHIFT, 1, movetoworkspace, 1"
      "SUPER_SHIFT, 2, movetoworkspace, 2"
      "SUPER_SHIFT, 3, movetoworkspace, 3"
      "SUPER_SHIFT, 4, movetoworkspace, 4"
      "SUPER_SHIFT, 5, movetoworkspace, 5"
      "SUPER_SHIFT, 6, movetoworkspace, 6"
      "SUPER_SHIFT, 7, movetoworkspace, 7"
      "SUPER_SHIFT, 8, movetoworkspace, 8"
      "SUPER_SHIFT, 9, movetoworkspace, 9"
      "SUPER_SHIFT, 0, movetoworkspace, 10"
      "SUPER, S, togglespecialworkspace, magic"
      "SUPER_SHIFT, S, movetoworkspace, special:magic"
      "SUPER, mouse_down, workspace, e+1"
      "SUPER, mouse_up, workspace, e-1"
    ];

    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
      "SUPER, ALT_L, resizewindow"
    ];

    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
