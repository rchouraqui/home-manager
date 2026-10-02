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
    enable = true;
    hyprland = {
      enable = true;
      primaryMonitor = "eDP-1";
      isLaptop = true;
      usingAMD = true;
      monitors = [
        "eDP-1, 2560x1600@165, 0x-1080, 1.60"
        "DP-10, 1920x1080@100, 0x0, 1" # Asus monitor
        "DP-9, 1920x1080@60, 1920x0, 1, transform, 1" # Samsung monitor
        ", preferred, auto, 1" # plug a random monitor
      ];
    };
    hypridle = true;
    hyprlock = true;
    hyprpaper = true;
    vicinae = true;
    waybar = true;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = "mauve";
    flavor = "mocha";
  };

  application = {
    enable = true;
    kitty = true;
    prismlauncher = true;
    vesktop = true;
    microsoft-edge = true;
    cisco-packet-tracer = false;
    libreoffice = true;
    obsidian = true;
    fonts = true;
    vlc = true;
    evince = true;
    imv = true;
    nautilus = true;
    zen = true;
    element = true;
    blender = true;
    godot = true;
    spice = true;
  };

}
