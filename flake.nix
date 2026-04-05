{
  description = "My NixOS flake";

  inputs = {
    unstablepkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pwndbg = {
      url = "github:pwndbg/pwndbg";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    ctf-skills = {
      url = "github:ljagiello/ctf-skills";
      flake = false;
    };

    awesome-claude-skills = {
      url = "github:ComposioHQ/awesome-claude-skills";
      flake = false;
    };

    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      hyprland,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      upkgs = import inputs.unstablepkgs {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs system upkgs; };

        modules = [

          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager

          hyprland.nixosModules.default

          inputs.noctalia.nixosModules.default

          inputs.sops-nix.nixosModules.sops

          inputs.nix-flatpak.nixosModules.nix-flatpak

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.huanghunr = {
              imports = [
                ./home/home.nix
                inputs.noctalia.homeModules.default
              ];
            };

            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
}
