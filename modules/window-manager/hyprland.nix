{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.window-manager.hyprland;

  clamshell = pkgs.writeShellScriptBin "clamshell" ''
    #!/usr/bin/env bash

    INTERNAL_DISPLAY=${cfg.primaryMonitor}

    ICON_LAPTOP="computer-laptop"
    ICON_MONITOR="video-display"

    notify_user() {
      notify-send -i "$3" "$1" "$2"
    }

    mode_close() {
      MONITORS_COUNT=$(hyprctl monitors all | grep -c "Monitor")
      if [[ $MONITORS_COUNT -gt 1 ]]; then
        hyprctl keyword monitor "$INTERNAL_DISPLAY, disable"
        sudo ${pkgs.systemd}/bin/systemctl stop fprintd.service
      fi
    }

    mode_open() {
      hyprctl keyword monitor ${pkgs.lib.head cfg.monitors}
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
in
{
  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        grim
        slurp
        wl-clipboard
        pavucontrol # GUI son
        networkmanagerapplet # fournit nm-connection-editor
        wireplumber # fournit wpctl
        playerctl # pour mpris
        brightnessctl # pour le module brightness
        blueman # GUI bluetooth
        lm_sensors # pour la température CPU
        swaynotificationcenter
        libnotify
      ]
      ++ lib.optionals (cfg.isLaptop) [
        clamshell
      ];

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
      configType = "hyprlang";
      systemd = {
        enable = true;
        variables = [
          "--all"
        ];
      };
      xwayland.enable = true;
      settings = {
        monitor = cfg.monitors;
        #framework-monitor
        #"DP-10, 1920x1080@100, 0x0, 1" # Asus monitor
        #"DP-9, 1920x1080@60, 1920x0, 1, transform, 1" # Samsung monitor
        #", preferred, auto, 1" # plug a random monitor

        "exec-once" = [
          "waybar"
          "swaync"
          "nm-applet --indicator"
          "blueman-applet"
          "hyprpaper"
        ];

        exec = "clamshell check";

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
        ]
        ++ lib.optionals (cfg.usingNVIDIA) [
          "LIBVA_DRIVER_NAME=nvidia"
          "__GLX_VENDOR_LIBRARY_NAME=nvidia"
          "__NV_PRIME_RENDER_OFFLOAD=1"
          "__GL_SYNC_TO_VBLANK=0"
          "__GL_THREADED_OPTIMIZATIONS=1"
          "NVD_BACKEND=direct"

        ]
        ++ lib.optionals (cfg.usingAMD) [
          "LIBVA_DRIVER_NAME=radeonsi"
          "VDPAU_DRIVER=radeonsi"
        ];

        general = {
          gaps_in = 3;
          gaps_out = 5;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
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

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;

          bezier = [
            "easeOutQuint,   0.23, 1,    0.32, 1"
            "easeInOutCubic, 0.65, 0.05, 0.36, 1"
            "linear,         0,    0,    1,    1"
            "almostLinear,   0.5,  0.5,  0.75, 1"
            "quick,          0.15, 0,    0.1,  1"
          ];

          animation = [
            "global,        1,     10,    default"
            "border,        1,     5.39,  easeOutQuint"
            "windows,       1,     4.79,  easeOutQuint"
            "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
            "windowsOut,    1,     1.49,  linear,       popin 87%"
            "fadeIn,        1,     1.73,  almostLinear"
            "fadeOut,       1,     1.46,  almostLinear"
            "fade,          1,     3.03,  quick"
            "layers,        1,     3.81,  easeOutQuint"
            "layersIn,      1,     4,     easeOutQuint, fade"
            "layersOut,     1,     1.5,   linear,       fade"
            "fadeLayersIn,  1,     1.79,  almostLinear"
            "fadeLayersOut, 1,     1.39,  almostLinear"
            "workspaces,    1,     1.94,  almostLinear, fade"
            "workspacesIn,  1,     1.21,  almostLinear, fade"
            "workspacesOut, 1,     1.94,  almostLinear, fade"
            "zoomFactor,    1,     7,     quick"
          ];
        };

        dwindle = {
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };

        input = {
          kb_layout = "us";
          kb_variant = "intl";

          follow_mouse = 1;

          sensitivity = 0;

          touchpad = {
            natural_scroll = false;
          };
        };

        gesture = "3, horizontal, workspace";

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        "$mainMod" = "SUPER";
        "$menu" = "vicinae toggle";

        bind = [
          "$mainMod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
          "$mainMod, Q, killactive,"
          "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
          "$mainMod, E, exec, ${pkgs.nautilus}/bin/nautilus"
          "$mainMod, V, togglefloating,"
          "$mainMod, SPACE, exec, $menu"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod, J, layoutmsg, togglesplit"
          "$mainMod, W, exec, zen-beta"
          "$mainMod, N, exec, swaync-client -t -sw"
          "$mainMod, L, exec, hyprlock"

          "$mainMod SHIFT, S, exec, bash -c 'f=~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png; grim -g \"$(slurp)\" $f && wl-copy --type image/png < $f'"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          #"$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        # Laptop multimedia keys for volume and LCD brightness
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];

        bindl = [
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
          ",XF86AudioLowerVolume, exec, pamixer -d 5"
          ",XF86AudioRaiseVolume, exec, pamixer -i 5"
          ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
          ",XF86MonBrightnessUp, exec, brightnessctl set 10%+ "
          ", switch:on:Lid Switch, exec, clamshell close"
          ", switch:off:Lid Switch, exec, clamshell open"
        ];

        windowrule = [
          {
            name = "suppress-maximize-events";
            "match:class" = ".*";
            suppress_event = "maximize";
          }

          {
            name = "fix-xwayland-drags";
            "match:class" = "^$";
            "match:title" = "^$";
            "match:xwayland" = true;
            "match:float" = true;
            "match:fullscreen" = false;
            "match:pin" = false;
            no_focus = true;
          }

          {
            name = "move-hyprland-run";
            "match:class" = "hyprland-run";
            move = "20 monitor_h-120";
            float = true;
          }
        ];

        workspace = [
          "1, monitor:DP-10"
          "10, monitor:DP-9"
        ];

      };
    };
  };
}
