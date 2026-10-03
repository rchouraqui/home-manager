{
  description = "Full NixOS configuration of home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:EniumRaphael/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      zen-browser,
      hyprland,
      catppuccin,
      nixvim,
      ...
    }:
    let
      lib = nixpkgs.lib;

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkHomeConfig =
        {
          system,
          modulePath,
        }:
        let
          pkgs = pkgsFor system;
          sys = pkgs.stdenv.hostPlatform.system;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            catppuccin.homeModules.catppuccin
            modulePath
          ];
          extraSpecialArgs = {
            inherit inputs;
            nixvim = nixvim.packages.${sys}.default;
            zen-browser = if zen-browser.packages ? ${sys} then zen-browser.packages.${sys}.default else null;
          };
        };

      hosts = {
        root = {
          system = "x86_64-linux";
          path = ./host/root.nix;
        };
        framework = {
          system = "x86_64-linux";
          path = ./host/framework.nix;
        };
        fix = {
          system = "x86_64-linux";
          path = ./host/fix.nix;
        };
        server = {
          system = "x86_64-linux";
          path = ./host/server.nix;
        };
      };
    in
    {
      homeConfigurations = lib.mapAttrs (
        _: h:
        mkHomeConfig {
          system = h.system;
          modulePath = h.path;
        }
      ) hosts;

      homeModules = lib.mapAttrs (_: h: h.path) hosts;
    };
}
