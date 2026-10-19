{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  firefox-addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.application.zen;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  config = lib.mkIf cfg {
    programs = {
      zen-browser = {
        enable = cfg;
        setAsDefaultBrowser = true;
        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = false;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          ExtensionSettings = {
            "*" = {
              blocked_install_message = "";
              install_sources = [ "https://addons.mozilla.org/*" ];
              installation_mode = "allowed";
            };
            "addon@bitwarden.com" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
              default_area = "navbar";
              private_browsing = false;
            };
            "cookie-editor@cgagnier.ca" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/cookie-editor/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
            "addon@darkreader.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
            "foxyproxy@eric.h.jung" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/foxyproxy-standard/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
            "extension@return-youtube-dislikes.com" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
            "sponsorBlocker@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              default_area = "navbar";
              private_browsing = true;
            };
            "vimium-c@gdh1995.cn" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi";
              default_area = "menupanel";
              private_browsing = true;
            };
            "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
            "wayback_machine@mozilla.org" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/wayback-machine/latest.xpi";
              default_area = "menupanel";
              private_browsing = false;
            };
          };
        };
        nativeMessagingHosts = [
          pkgs.bitwarden-desktop
        ];
        profiles."default" = {
          pinsForce = true;
          pinsForceAction = "remove";
          pins = {
            "YouTube" = {
              id = "b2c3d4e5-f6a7-8901-bcde-f12345678901";
              url = "https://www.youtube.com";
              position = 104;
              isEssential = true;
            };
            "Github" = {
              id = "d4e5f6a7-b8c9-0123-defa-234567890122";
              url = "https://github.com";
              position = 105;
              isEssential = true;
            };
          };
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Homelab";
                bookmarks = [
                  {
                    name = "pfsense";
                    url = "https://10.0.10.1";
                  }
                  {
                    name = "zyxel";
                    url = "https://10.0.10.2";
                  }
                  {
                    name = "pve";
                    url = "https://10.0.10.5";
                  }
                  {
                    name = "truenas";
                    url = "https://10.0.10.3";
                  }
                  {
                    name = "cloudflare";
                    url = "https://dash.cloudflare.com/login?redirect_uri=%2F67d859ff395966585b61f93e3eee6dfc%2Fdprive.fr%2Fdns%2Frecords";
                  }
                  {
                    name = "nextcloud";
                    url = "https://nextcloud.dprive.fr";
                  }
                  {
                    name = "immich";
                    url = "https://immich.dprive.fr";
                  }
                  {
                    name = "jellyfin";
                    url = "https://jellyfin.dprive.fr";
                  }
                  {
                    name = "radarr";
                    url = "https://radarr.dprive.fr";
                  }
                  {
                    name = "sonarr";
                    url = "https://sonarr.dprive.fr";
                  }
                  {
                    name = "htop";
                    url = "https://htop.dprive.fr";
                  }
                ];
              }
              {
                name = "3d";
                bookmarks = [
                  {
                    name = "makerword";
                    url = "https://makerworld.com/fr";
                  }
                  {
                    name = "printables";
                    url = "https://www.printables.com/";
                  }
                  {
                    name = "onshape";
                    url = "https://cad.onshape.com/signin";
                  }
                  {
                    name = "Sunlu";
                    url = "https://sunlu.fr/";
                  }
                ];
              }
              {
                name = "nix";
                bookmarks = [
                  {
                    name = "nixos-wiki";
                    url = "https://nixos.wiki/wiki/Main_Page";
                  }
                  {
                    name = "mynixos";
                    url = "https://mynixos.com/";
                  }
                ];
              }
              {
                name = "Licence";
                bookmarks = [
                  {
                    name = "openclassrooms";
                    url = "https://openclassrooms.com/fr/spaces/student/dashboard";
                  }
                  {
                    name = "circle";
                    url = "https://community.openclassrooms.com/feed";
                  }
                  {
                    name = "claude";
                    url = "https://claude.ai/new";
                  }
                ];
              }
            ];
          };
          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";
          };
          extensions = {
            force = true;
            packages = with firefox-addons; [
              bitwarden
              cookie-editor
              darkreader
              foxyproxy-standard
              return-youtube-dislikes
              sponsorblock
              ublock-origin
              vimium-c
              violentmonkey
              wayback-machine
            ];
          };
          settings = {
            # UI
            "ui.textScaleFactor" = 120;
            "browser.uidensity" = 1;
            "browser.theme.content-theme" = 0;
            "browser.theme.toolbar-theme" = 0;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # Zen
            "zen.view.compact.enable-at-startup" = true;
            "zen.theme.accent-color" = "#8caaee";
            "zen.tabs.vertical.right-side" = false;
            "zen.view.use-single-toolbar" = false;
            "zen.welcome-screen.seen" = true;

            # Privacy
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.sanitize.sanitizeOnShutdown" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.cookies" = false;
            "privacy.clearOnShutdown.cache" = true;
            "privacy.clearOnShutdown.downloads" = false;

            # Telemetry
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "browser.ping-centre.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;

            # Network
            "network.dns.disablePrefetch" = true;
            "network.prefetch-next" = false;
            "network.http.speculative-parallel-limit" = 0;

            # Passwords
            "signon.rememberSignons" = false;
            "signon.autofillForms" = false;

            # Performance
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.hardware-decoding.force-enabled" = true;

            # Misc
            "browser.shell.checkDefaultBrowser" = false;
            "browser.startup.page" = 3;
            "browser.sessionstore.resume_from_crash" = true;
            "browser.newtabpage.enabled" = false;
            "browser.download.useDownloadDir" = true;
          };
        };
      };
    };
  };
}
