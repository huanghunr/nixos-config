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
        duckdb
        bookmarks
        ;
    };
    initLua = "
    require(\"git\"):setup()
    require(\"recycle-bin\"):setup()
    require(\"duckdb\"):setup()
    require(\"bookmarks\"):setup({
	    last_directory = { enable = false, persist = false, mode=\"dir\" },
      persist = \"all\",
      desc_format = \"full\",
      file_pick_mode = \"hover\",
      custom_desc_input = false,
      show_keys = false,
      notify = {
        enable = true,
        timeout = 1,
        message = {
          new = \"New bookmark '<key>' -> '<folder>'\",
          delete = \"Deleted bookmark in '<key>'\",
          delete_all = \"Deleted all bookmarks\",
        },
      },
    })
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
        {
          on = [ "H" ];
          run = "plugin duckdb -1";
          desc = "Scroll one column to the left";
        }

        {
          on = [ "L" ];
          run = "plugin duckdb +1";
          desc = "Scroll one column to the right";
        }

        {
          on = [
            "g"
            "o"
          ];
          run = "plugin duckdb -open";
          desc = "open with duckdb";
        }

        {
          on = [
            "g"
            "u"
          ];
          run = "plugin duckdb -ui";
          desc = "open with duckdb ui";
        }
        {
          on = [ "m" ];
          run = "plugin bookmarks save";
          desc = "Save current position as a bookmark";
        }

        {
          on = [ "'" ];
          run = "plugin bookmarks jump";
          desc = "Jump to a bookmark";
        }

        {
          on = [
            "b"
            "d"
          ];
          run = "plugin bookmarks delete";
          desc = "Delete a bookmark";
        }

        {
          on = [
            "b"
            "D"
          ];
          run = "plugin bookmarks delete_all";
          desc = "Delete all bookmarks";
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
        prepend_previewers = [
          {
            name = "*.csv";
            run = "duckdb";
          }
          {
            name = "*.tsv";
            run = "duckdb";
          }
          {
            name = "*.json";
            run = "duckdb";
          }
          {
            name = "*.parquet";
            run = "duckdb";
          }
          {
            name = "*.txt";
            run = "duckdb";
          }
          {
            name = "*.xlsx";
            run = "duckdb";
          }
          {
            name = "*.db";
            run = "duckdb";
          }
          {
            name = "*.duckdb";
            run = "duckdb";
          }
        ];
      };
    };
  };
}
