{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  hyprland = import ./hyprland.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  hypridle = import ./hypridle.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  hyprlock = import ./hyprlock.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  hyprpaper = import ./hyprpaper.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  vicinae = import ./vicinae.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  waybar = import ./waybar.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };

  cfg = config.window-manager;

in
{
  imports = [
    hyprland
    hypridle
    hyprlock
    hyprpaper
    vicinae
    waybar
  ];

  options.window-manager = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the configuration of the window-manager";
    };
    hyprland = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Hyprland configuration";
      };
      primaryMonitor = lib.mkOption {
        type = lib.types.str;
        default = "eDP-1";
        description = "The default monitor for hyprland";
      };
      monitors = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ",preferred,auto,1" ];
        description = "Monitor configuration";
      };
      usingAMD = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the amd var loading";
      };
      usingNVIDIA = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the nvidia var loading";
      };
      isLaptop = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the laptop";
      };
    };
    hypridle = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the configartion of hypridle";
    };
    hyprlock = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the configartion of hyprlock";
    };
    hyprpaper = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the configartion of hyprpaper";
    };
    vicinae = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the configartion of vicinae";
    };
    waybar = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the configartion of waybar";
    };
  };

  config = lib.mkIf (!config.window-manager.enable) {
    window-manager = {
      hyprland.enable = false;
      hyprlock = false;
      hyprpaper = false;
      hypridle = false;
      vicinae = false;
      waybar = false;
    };

    catppuccin.accent = "mauve";

    xdg.userDirs = {
      enable = true;
      setSessionVariables = true;
      createDirectories = true;
    };
  };
}
