{
  system,
  inputs,
  config,
  pkgs,
  lib,
  zen-browser,
  nixvim,
  ...
}:

let
  window-manager = import ../modules/window-manager/default.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  shell = import ../modules/shell/default.nix {
    inherit
      inputs
      config
      pkgs
      lib
      nixvim
      ;
  };
  packages = import ../modules/packages/default.nix {
    inherit
      inputs
      config
      pkgs
      lib
      zen-browser
      ;
  };
in
{
  imports = [
    packages
    shell
    window-manager
  ];

  home = {
    username = "raph";
    homeDirectory = "/home/raph";
    stateVersion = "24.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  shell = {
    enable = true;
    starship = true;
    git = true;
    nixvim = true;
    lazygit = true;
  };

  window-manager = {
    enable = false;
    hyprland = {
      enable = false;
      primaryMonitor = " ";
      usingNVIDIA = false;
      monitors = [
        ", preferred, auto, 1" # plug a random monitor
      ];
    };
    hypridle = false;
    hyprlock = false;
    hyprpaper = false;
    vicinae = false;
    waybar = false;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  application = {
    enable = false;
    kitty = false;
    prismlauncher = false;
    vesktop = false;
    microsoft-edge = false;
    cisco-packet-tracer = false;
    libreoffice = false;
    obsidian = false;
    fonts = false;
    vlc = false;
    evince = false;
    imv = false;
    nautilus = false;
    zen = false;
    element = false;
    blender = false;
    godot = false;
    spice = false;
  };
}
