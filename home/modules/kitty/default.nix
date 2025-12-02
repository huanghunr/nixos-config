{ config, pkgs, ... }:

{
  programs = {
    kitty = {
      enable = true;
      font.name = "jetbrains mono nerd font";
      font.size = 12;
      settings = {
        italic_font = "auto";
        bold_italic_font = "auto";
        mouse_hide_wait = 2;
        cursor_shape = "beam";
        cursor_trail = 0;
        url_color = "#0087bd";
        url_style = "dotted";
        #Close the terminal =  without confirmation;
        confirm_os_window_close = 0;
        background_opacity = "0.9";
        background_blur = "20";
      };
      extraConfig = ''

        foreground            #e0def4
        background            #191724
        selection_foreground  #191724
        selection_background  #e0def4
        url_color             #0087BD
        cursor                #e0def4
        cursor_text_color     #191724

        # black
        color0   #26233a
        color8   #6e6a86

        # red
        color1   #eb6f92
        color9   #eb6f92

        # green
        color2   #31748f
        color10  #f6c117

        # yellow
        color3   #f6c117
        color11  #f6c117

        # blue
        color4  #9ccfd8
        color12 #9ccfd8

        # magenta
        color5   #c4a7e7
        color13  #c4a7e7

        # cyan
        color6   #ebbcba
        color14  #ebbcba

        # white
        color7   #e0def4
        color15  #eceff4
      '';
    };
  };
}