{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.window-manager.noctalia;
  wallpaper = "/home/${config.home.username}/Pictures/";
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  config = lib.mkIf cfg {
    programs.noctalia = {
      enable = true;

      settings = {
        bar = {
          order = [ "default" ];
          default = {
            background_opacity = 0.0;
            capsule = true;
            capsule_border = "primary_container";
            capsule_fill = "on_hover";
            capsule_foreground = "hover";
            capsule_opacity = 0.75;
            capsule_padding = 7.0;
            capsule_thickness = 0.77;
            compositor_blur = false;
            font_family = "Fira Code";
            margin_ends = 5;
            padding = 0;
            start = [
              "launcher"
              "wallpaper"
              "workspaces"
              "taskbar"
            ];
            center = [
              "date"
              "audio_visualizer"
              "clock"
            ];
            end = [
              "tray"
              "clipboard"
              "cpu"
              "ram"
              "network"
              "bluetooth"
              "volume"
              "brightness"
              "battery"
              "session"
            ];
          };
        };

        desktop_widgets = {
          schema_version = 2;
          widget_order = [ ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
        };

        location.address = "Paris";

        lockscreen.fingerprint = false;

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@HDMI-A-2"
            "lockscreen-login-box@DP-4"
            "lockscreen-widget-0000000000000001"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
            "lockscreen-login-box@DP-4" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 540.0;
              cy = 1738.0;
              output = "DP-4";
              placement_height = 1920.0;
              placement_width = 1080.0;
              rotation = 0.0;
              type = "login_box";
              settings = {
                background_color = "surface_container";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_media_controls = true;
                show_password_reveal = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-login-box@HDMI-A-2" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 960.0;
              cy = 898.0;
              output = "HDMI-A-2";
              placement_height = 1080.0;
              placement_width = 1920.0;
              rotation = 0.0;
              type = "login_box";
              settings = {
                background_color = "surface_container";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_media_controls = true;
                show_password_reveal = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };

            "lockscreen-widget-0000000000000001" = {
              box_height = 144.0;
              box_width = 368.0;
              cx = 960.0;
              cy = 244.0;
              output = "HDMI-A-2";
              placement_height = 1080.0;
              placement_width = 1920.0;
              rotation = 0.0;
              type = "clock";
            };
          };
        };

        shell = {
          font_family = "FiraCode Nerd Font";
          lang = "fr";
          polkit_agent = true;
          panel.floating_offset = 3;
        };

        theme = {
          builtin = "Catppuccin";
          mode = "dark";
          source = "wallpaper";
          wallpaper_scheme = "m3-content";
          templates.builtin_ids = [
            "btop"
            "gtk3"
            "gtk4"
            "hyprland"
            "kcolorscheme"
            "kitty"
            "qt"
          ];
        };

        wallpaper = {
          default.path = wallpaper;
          monitors = {
            DP-4.path = wallpaper;
            HDMI-A-2.path = wallpaper;
          };
        };

        widget = {
          audio_visualizer.width = 100.0;
          clock.timezone = "Europe/Paris";
        };
      };
    };
  };
}
