{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # Manually packaging and enable a plugin
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
          sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
        };
      }
    ];
    
    shellAliases = {
      ll = "ls -la";
      cl = "clear";
      dls = "distrobox ls";
      den = "distrobox enter";
      dst = "distrobox stop";
      dstr = "distrobox";
    };

    functions = {
      proxy_s = ''
        set http_proxy "http://127.0.0.1:7897"
        set https_proxy "http://127.0.0.1:7897"
        set all_proxy "http://127.0.0.1:7897"
        echo "Proxy enabled"
      '';

      unproxy_s = ''
        set -e http_proxy
        set -e https_proxy
        set -e all_proxy
        echo "Proxy disabled"
      '';
    };
  };
}
