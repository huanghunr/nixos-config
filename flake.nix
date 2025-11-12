{
  description = "My NixOS flake";

  inputs = {
    # NixOS source nixos-25.05 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # home-manager, used for managing user configuration
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs dependencies.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... }@inputs: {
    # 我的 hostname 是 nixos
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      modules = [
        # import configuration.nix
        ./nixos/configuration.nix
        # 将 home-manager 配置为 nixos 的一个 module
        # 这样在 nixos-rebuild switch 时，home-manager 配置也会被自动部署
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

          # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
          # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
          # home-manager.extraSpecialArgs = inputs;
        }
      ];
    };
  };
}
