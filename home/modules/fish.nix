{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      # # Enable a plugin (here grc for colorized command output) from nixpkgs
      # {
      #   name = "grc";
      #   src = pkgs.fishPlugins.grc.src;
      # }
      # # Manually packaging and enable a plugin
      # {
      #   name = "z";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "jethrokuan";
      #     repo = "z";
      #     rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      #     sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      #   };
      # }
      pkgs.fishPlugins.fishPlugins.z
      pkgs.fishPlugins.grc
    ];
    shellAliases = {
      ll = "ls -la";
    };
    functions = {
      proxy = ''
        set -gx http_proxy "http://127.0.0.1:7897"
        set -gx https_proxy "http://127.0.0.1:7897"
        set -gx all_proxy "http://127.0.0.1:7897"
        echo "Proxy enabled"
      '';

      unproxy = ''
        set -e http_proxy
        set -e https_proxy
        set -e all_proxy
        echo "Proxy disabled"
      '';
    };
  };
}
