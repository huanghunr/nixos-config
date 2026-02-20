{ pkgs, ... }:

let
  getFrom =
    {
      url,
      hash,
      name,
    }:
    {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = name;
      size = 24;
      package = pkgs.runCommand "moveUp" { } ''
        mkdir -p $out/share/icons
        ln -s ${
          pkgs.fetchzip {
            url = url;
            hash = hash;
          }
        } $out/share/icons/${name}
      '';
    };

  Bibata-Modern-Ice = getFrom {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz";
    hash = "sha256-SG/NQd3K9DHNr9o4m49LJH+UC/a1eROUjrAQDSn3TAU=";
    name = "Bibata-Modern-Ice";
  };

  Bibata-Original-Ice = getFrom {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Original-Ice.tar.xz";
    hash = "sha256-RdOXxVXQ1YMfFbP3bktNnOQBhHMgfjjGsp0bJVQZ39c=";
    name = "Bibata-Original-Ice";
  };

in
{
  home.pointerCursor = Bibata-Original-Ice;

  # DPI and Xresources
  xresources.properties = {
    "Xft.dpi" = 172;
  };
}
