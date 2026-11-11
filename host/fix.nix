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
      primaryMonitor = "HDMI-A-2";
      usingNVIDIA = true;
      monitors = [
        {
          output = "HDMI-A-2";
          mode = "1920x1080@100";
          position = "0x0";
          scale = 1;
          transform = 0;
        }
        {
          output = "DP-4";
          mode = "1920x1080@60";
          position = "1920x0";
          scale = 1;
          transform = 1;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];
      workspaces = [
        {
          workspace = "1";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "2";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "3";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "4";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "5";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "6";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "7";
          monitor = "DP-4";
        }
        {
          workspace = "8";
          monitor = "DP-4";
        }
        {
          workspace = "9";
          monitor = "DP-4";
        }
        {
          workspace = "10";
          monitor = "DP-4";
        }
      ];
    };
    hypridle = true;
    hyprlock = false;
    hyprpaper = false;
    vicinae = true;
    waybar = false;
    noctalia = true;
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
    virt-viewer = true;
  };
}
