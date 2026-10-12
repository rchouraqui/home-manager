{
  inputs,
  config,
  pkgs,
  lib,
  zen-browser,
  ...
}:

let
  kitty = import ./kitty.nix {
    inherit
      inputs
      config
      pkgs
      lib
      ;
  };
  cfg = config.application;
in
{
  imports = [
    kitty
    inputs.zen-browser.homeModules.beta
  ];

  options.application = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the applications";
    };
    vesktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Vesktop";
    };
    microsoft-edge = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Microsoft Edge";
    };
    prismlauncher = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Prismlauncher";
    };
    cisco-packet-tracer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the CiscoPacketTracer";
    };
    libreoffice = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the LibreOffice";
    };
    obsidian = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Obsidian";
    };
    fonts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Fonts";
    };
    vlc = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the VLC";
    };
    evince = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Evince";
    };
    imv = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the IMV";
    };
    nautilus = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Nautilus";
    };
    kitty = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Kitty";
    };
    zen = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Zen Browser";
    };
    element = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the element Desktop";
    };
    blender = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the blender Desktop";
    };
    godot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the godot Desktop";
    };
    spice = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the spice Desktop";
    };
    virt-viewer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the virt-viewer";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zen-browser.enable = cfg.zen;
    };
    home.packages =
      with pkgs;
      (
        if cfg.prismlauncher then
          [
            prismlauncher
            openjdk
            oversteer
          ]
        else
          [ ]
      )
      ++ (
        if cfg.element then
          [
            element-desktop
            libsecret
          ]
        else
          [ ]
      )
      ++ (if cfg.vesktop then [ vesktop ] else [ ])
      ++ (if cfg.microsoft-edge then [ microsoft-edge ] else [ ])
      ++ (if cfg.cisco-packet-tracer then [ cisco-packet-tracer_9 ] else [ ])
      ++ (if cfg.libreoffice then [ libreoffice ] else [ ])
      ++ (if cfg.obsidian then [ obsidian ] else [ ])
      ++ (
        if cfg.fonts then
          with pkgs.nerd-fonts;
          [
            fira-code
            jetbrains-mono
          ]
        else
          [ ]
      )
      ++ (if cfg.vlc then [ vlc ] else [ ])
      ++ (if cfg.evince then [ evince ] else [ ])
      ++ (if cfg.imv then [ imv ] else [ ])
      ++ (if cfg.nautilus then [ nautilus ] else [ ])
      ++ (if cfg.blender then [ blender ] else [ ])
      ++ (if cfg.godot then [ godot ] else [ ])
      ++ (if cfg.spice then [ spice ] else [ ])
      ++ (if cfg.virt-viewer then [ virt-viewer ] else [ ]);
  };
}
