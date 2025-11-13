{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # pkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland"; # Prevents version mismatch.
    };

  };

  outputs = { self, nixpkgs, home-manager, catppuccin, hyprland-plugins, ... }@inputs:
  let
    system = "x86_64-linux";

    # 导入两个不同版本的 nixpkgs
    # pkgs = import nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    # };

    # pkgs-master = import nixpkgs-master {
    #   inherit system;
    #   config.allowUnfree = true;
    # };
  in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./nixos/configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.huanghunr = {
            imports = [
              ./home/home.nix
              catppuccin.homeModules.catppuccin
            ];
          };

          # 如果希望在 home.nix 里直接访问 inputs，也可以加上这行：
          home-manager.extraSpecialArgs = inputs;
        }
      ];
    };
  };
}
