{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
    plugins = {
      inherit (pkgs.yaziPlugins)
        wl-clipboard
        mount
        git
        recycle-bin
        compress
        chmod
        ;
    };
    initLua = "
    require(\"git\"):setup()
    require(\"recycle-bin\"):setup()
      ";
    keymap = {
      mgr.prepend_keymap = [
        {
          run = "plugin wl-clipboard";
          on = [ "<C-y>" ];
        }
        {
          run = "plugin mount";
          on = [ "M" ];
        }
        {
          on = [
            "R"
            "b"
          ];
          run = "plugin recycle-bin";
          desc = "Open Recycle Bin menu";
        }
        {
          on = [
            "c"
            "a"
            "a"
          ];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = [
            "c"
            "a"
            "a"
          ];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = [
            "c"
            "a"
            "p"
          ];
          run = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
        {
          on = [
            "c"
            "a"
            "h"
          ];
          run = "plugin compress -ph";
          desc = "Archive selected files (password+header)";
        }
        {
          on = [
            "c"
            "a"
            "l"
          ];
          run = "plugin compress -l";
          desc = "Archive selected files (compression level)";
        }
        {
          on = [
            "c"
            "a"
            "u"
          ];
          run = "plugin compress -phl";
          desc = "Archive selected files (password+header+level)";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };
    settings = {
      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
        ];
        prepend_previewers =[
        ];
      };
    };
  };
}
