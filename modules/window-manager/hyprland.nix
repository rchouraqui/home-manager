{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.window-manager.hyprland;
  mod = "SUPER";
  ipc = "noctalia msg";
  lua = lib.generators.mkLuaInline;
  toLua = lib.generators.toLua { multiline = false; };
  exec = cmd: "hl.dsp.exec_cmd(${builtins.toJSON cmd})";
  bind = key: dsp: opts: {
    _args = [
      key
      (lua dsp)
    ]
    ++ lib.optional (opts != { }) opts;
  };

  monitorOpen = "hl.monitor(${toLua ((lib.head cfg.monitors) // { disabled = false; })})";

  clamshell = pkgs.writeShellScriptBin "clamshell" ''
    INTERNAL_DISPLAY=${cfg.primaryMonitor}

    ICON_LAPTOP="computer-laptop"
    ICON_MONITOR="video-display"

    notify_user() {
      ${pkgs.libnotify}/bin/notify-send -i "$3" "$1" "$2"
    }

    mode_close() {
      MONITORS_COUNT=$(hyprctl monitors all | grep -c "Monitor")
      if [[ $MONITORS_COUNT -gt 1 ]]; then
        hyprctl eval "hl.monitor({ output = \"$INTERNAL_DISPLAY\", disabled = true })"
        sudo ${pkgs.systemd}/bin/systemctl stop fprintd.service
      fi
    }

    mode_open() {
      hyprctl eval '${monitorOpen}'
      sudo ${pkgs.systemd}/bin/systemctl start fprintd.service
    }

    if [[ "$1" == "close" ]]; then
      mode_close
      notify_user "Clamshell Mode" "External monitor active. Laptop screen disabled." "$ICON_MONITOR"

    elif [[ "$1" == "open" ]]; then
      mode_open
      notify_user "Laptop Mode" "Laptop screen enabled." "$ICON_LAPTOP"

    elif [[ "$1" == "check" ]]; then
      if grep -q "open" /proc/acpi/button/lid/*/state; then
        mode_open
      else
        mode_close
      fi

    else
      echo "Usage: clamshell [open|close|check]"
      exit 1
    fi
  '';

  envVars = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  }
  // lib.optionalAttrs cfg.usingNVIDIA {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __GL_SYNC_TO_VBLANK = "0";
    __GL_THREADED_OPTIMIZATIONS = "1";
    NVD_BACKEND = "direct";
  }
  // lib.optionalAttrs cfg.usingAMD {
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };

  startup = [
    ''hyprctl setcursor "Catppuccin-Mocha-Dark" 24''
    "pw-metadata -n settings 0 clock.force-quantum 512"
    "xrandr --output ${cfg.primaryMonitor} --primary"
    "noctalia"
    "nm-applet --indicator"
    "blueman-applet"
    "zen-beta"
    "vesktop"
    "element-desktop"
  ]
  ++ lib.optionals cfg.isLaptop [
    "upower"
    "clamshell check"
  ];

  startupFn = ''
    function()
    ${lib.concatMapStringsSep "\n" (c: "  hl.exec_cmd(${builtins.toJSON c})") startup}
    end'';
  reloadFn = ''
    function()
      hl.exec_cmd("clamshell check")
    end'';

  workspaceKeys = lib.range 1 10;
  keyOf = i: if i == 10 then "0" else toString i;

  binds = [
    (bind "${mod} + Q" "hl.dsp.window.close()" { })
    (bind "${mod} + RETURN" (exec "${pkgs.kitty}/bin/kitty") { })
    (bind "${mod} + W" (exec "zen-beta") { })
    (bind "${mod} + E" (exec "${pkgs.nautilus}/bin/nautilus") { })
    (bind "${mod} + N" (exec "swaync-client -t -sw") { })
    (bind "${mod} + SPACE" (exec "vicinae toggle") { })
    (bind "${mod} + M" "hl.dsp.exit()" { })
    (bind "${mod} + J" "hl.dsp.layout(\"togglesplit\")" { })
    (bind "${mod} + L" (exec "${ipc} session lock") { })

    (bind "${mod} + SHIFT + L" (exec "hyprlock") { })
    (bind "${mod} + V" ''hl.dsp.window.float({ action = "toggle" })'' { })
    (bind "${mod} + F" "hl.dsp.window.fullscreen()" { })

    (bind "${mod} + left" ''hl.dsp.focus({ direction = "left" })'' { })
    (bind "${mod} + right" ''hl.dsp.focus({ direction = "right" })'' { })
    (bind "${mod} + up" ''hl.dsp.focus({ direction = "up" })'' { })
    (bind "${mod} + down" ''hl.dsp.focus({ direction = "down" })'' { })

    (bind "${mod} + SHIFT + left" ''hl.dsp.window.move({ direction = "left" })'' { })
    (bind "${mod} + SHIFT + right" ''hl.dsp.window.move({ direction = "right" })'' { })
    (bind "${mod} + SHIFT + up" ''hl.dsp.window.move({ direction = "up" })'' { })
    (bind "${mod} + SHIFT + down" ''hl.dsp.window.move({ direction = "down" })'' { })

    (bind "${mod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'' { })
    (bind "${mod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'' { })

    (bind "${mod} + SHIFT + S"
      (exec "bash -c 'f=~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png; grim -g \"$(slurp)\" $f && wl-copy --type image/png < $f'")
      { }
    )

    (bind "${mod} + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
    (bind "${mod} + mouse:273" "hl.dsp.window.resize()" { mouse = true; })

    (bind "XF86AudioPlay" (exec "${ipc} media toggle") { })
    (bind "XF86AudioPrev" (exec "${ipc} media previous") { })
    (bind "XF86AudioNext" (exec "${ipc} media next") { })

    (bind "XF86AudioLowerVolume" (exec "${ipc} volume-down 5") {
      locked = true;
      repeating = true;
    })
    (bind "XF86AudioRaiseVolume" (exec "${ipc} volume-up 5") {
      locked = true;
      repeating = true;
    })
    (bind "XF86MonBrightnessDown" (exec "${ipc} brightness-down all 5") {
      locked = true;
      repeating = true;
    })
    (bind "XF86MonBrightnessUp" (exec "${ipc} brightness-up all 5") {
      locked = true;
      repeating = true;
    })

    (bind "XF86AudioMute" (exec "${ipc} volume-mute") { locked = true; })

  ]
  ++ lib.optionals cfg.isLaptop [
    (bind "switch:on:Lid Switch" (exec "clamshell close") { locked = true; })
    (bind "switch:off:Lid Switch" (exec "clamshell open") { locked = true; })
  ]
  ++ map (
    i: bind "${mod} + ${keyOf i}" "hl.dsp.focus({ workspace = ${toString i} })" { }
  ) workspaceKeys
  ++ map (
    i: bind "${mod} + SHIFT + ${keyOf i}" "hl.dsp.window.move({ workspace = ${toString i} })" { }
  ) workspaceKeys;

  windowRules = [
    {
      name = "suppress-maximize-events";
      match.class = ".*";
      suppress_event = "maximize";
    }
    {
      name = "fix-xwayland-drags";
      match = {
        class = "^$";
        title = "^$";
        xwayland = true;
        float = true;
        fullscreen = false;
        pin = false;
      };
      no_focus = true;
    }
    {
      name = "vesktop";
      match.class = "vesktop";
      workspace = "10 silent";
    }
    {
      name = "element-desktop";
      match.class = "element-desktop";
      workspace = "10 silent";
    }
    {
      name = "PictureInPicture";
      match.title = "Picture-in-Picture";
      float = true;
      pin = true;
      size = "330, 186";
      move = "(monitor_w-337) 55";
    }
  ];
in
{
  config = lib.mkIf cfg.enable {

    home.packages =
      with pkgs;
      [
        grim
        slurp
        wl-clipboard
        networkmanagerapplet # fournit nm-connection-editor
        wireplumber # fournit wpctl
        playerctl # pour mpris
        brightnessctl # pour le module brightness
        blueman # GUI bluetooth
        lm_sensors # pour la température CPU
        swaynotificationcenter
        libnotify
      ]
      ++ lib.optionals cfg.isLaptop [ clamshell ];

    home.pointerCursor.enable = true;

    catppuccin = {
      hyprland.enable = false;
      cursors = {
        enable = true;
        accent = "dark";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "audio/*" = [ "vlc.desktop" ];
        "video/*" = [ "vlc.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];
        "text/plain" = [ "vim.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd.enable = true;
      xwayland.enable = true;

      settings = {
        config = {
          general = {
            gaps_in = 3;
            gaps_out = 5;
            border_size = 2;
            col = {
              active_border = {
                colors = [
                  "rgba(cba6f7ee)"
                  "rgba(89b4faee)"
                ];
                angle = 45;
              };
              inactive_border = "rgba(181825aa)";
            };
            resize_on_border = false;
            allow_tearing = false;
          };
          decoration = {
            rounding = 10;
            rounding_power = 2;
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            shadow = {
              enabled = true;
              range = 4;
              render_power = 3;
              color = "rgba(1a1a1aee)";
            };
          };
          input = {
            kb_layout = "us";
            kb_variant = "intl";
          }
          // lib.optionalAttrs cfg.isLaptop {
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
            };
          };
          dwindle = {
            preserve_split = true;
          };
        };

        env = lib.mapAttrsToList (name: value: {
          _args = [
            name
            value
          ];
        }) envVars;

        monitor = cfg.monitors;
        workspace_rule = cfg.workspaces;

        gesture = lib.optionals cfg.isLaptop [
          {
            fingers = 4;
            direction = "horizontal";
            action = "workspace";
          }
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
        ];

        bind = binds;
        window_rule = windowRules;

        on = [
          {
            _args = [
              "hyprland.start"
              (lua startupFn)
            ];
          }
        ]
        ++ lib.optionals cfg.isLaptop [
          {
            _args = [
              "config.reloaded"
              (lua reloadFn)
            ];
          }
        ];
      };
    };
  };
}
