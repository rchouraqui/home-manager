{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.shell.enable;
in
{
  config = lib.mkIf cfg {
    home = {
      packages = with pkgs; [
        eza
        wget
        unzip
        xclip
        nix-output-monitor
        perl
      ];
    };

    programs = {
      fastfetch = {
        enable = true;
      };
      zoxide = {
        enable = true;
      };
      bat = {
        enable = true;
        config.theme = "Catppuccin Mocha";
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
        enable = true;
        completionInit = ''
          autoload -U compinit
          compinit
        '';
        autosuggestion = {
          enable = true;
        };
        history = {
          append = true;
          expireDuplicatesFirst = false;
          extended = false;
          findNoDups = true;
          ignoreAllDups = true;
          ignoreDups = true;
          ignoreSpace = true;
          path = "${config.home.homeDirectory}/.zsh_history";
          save = 5000;
          share = true;
          size = 5000;
        };
        enableCompletion = true;
        autocd = true;
        historySubstringSearch = {
          enable = true;
        };
        shellAliases = {
          "cl" = "clear && fastfetch";
          "nrs" = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) |& nom";
          "hms" = "home-manager switch --flake ~/.config/home-manager#$(hostname) |& nom";
          "ls" = "eza -h --icons=always";
          "la" = "ls -a";
          "ll" = "ls -l";
          "lt" = "ls -T";
          "l" = "ls -l";
          "vim" = "nvim";
          "ssh" = "TERM=xterm-256color ssh";
          "vpn-on" = "sudo systemctl start wg-quick-wg0";
          "vpn-off" = "sudo systemctl stop wg-quick-wg0";
        };
        zplug = {
          enable = true;
          zplugHome = "${config.xdg.dataHome}/.zplug";
          plugins = [
            { name = "Aloxaf/fzf-tab"; }
            { name = "nix-community/nix-zsh-completions"; }
            { name = "z-shell/F-Sy-H"; }
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
          ];
        };
        envExtra = ''
          [ -f "$HOME/.zvars"  ] && source "$HOME/.zvars";
          [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]  && source "$HOME/.nix-profile/etc/profile.d/nix.sh"
          [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ] && source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
          [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ] && source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          [ -f /etc/zshenv ] && source /etc/zshenv
          [ -d ${pkgs.fzf} ] && source ${pkgs.fzf}/share/fzf/completion.zsh && source ${pkgs.fzf}/share/fzf/key-bindings.zsh
          if ! pgrep -u "$USER" ssh-agent > /dev/null; then
            eval "$(ssh-agent -s)"
          fi
        '';
        initContent = lib.mkMerge [
          (lib.mkAfter ''
            fzf_tab_preview() {
              if [[ -d $path ]]; then
                ${pkgs.eza}/bin/eza --icons=always --color=always "$1"
              else
                ${pkgs.bat}/bin/bat -p --color=always "$1"
              fi
            }

            if [ -f "$HOME/.config/bat/themes/Catppuccin\ Mocha.tmTheme" ]; then
              mkdir -p "$HOME/.config/bat/themes"
              wget -P "$HOME/.config/bat/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
            fi
          '')
          (lib.mkAfter ''
            zplug load
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' menu no

            bindkey '^R' fzf-history-widget
            bindkey '^[[1;5C' forward-word
            bindkey '^[[1;5D' backward-word
            bindkey '^[Oc' forward-word
            bindkey '^[Od' backward-word
            bindkey '^[[1;2D' beginning-of-line
            bindkey '^[[1;2C' end-of-line
            bindkey '^[[1;3D' beginning-of-line
            bindkey '^[[1;3C' end-of-line
            bindkey '^H' backward-kill-word
            bindkey -r '^['

            autoload -Uz zmv
            autoload -U edit-command-line
            zle -N edit-command-line
            bindkey '^x^e' edit-command-line
          '')
        ];
        loginExtra = ''
          eval "$(${pkgs.starship}/bin/starship init zsh)"
        '';
        sessionVariables = {
          MANPAGER = "/bin/sh -c 'col -bx | bat -l man --style=plain --paging=always'";
          MANROFFOPT = "-c";
          EDITOR = "nvim";
          FZF_CTRL_R_OPTS = "--layout reverse --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header='Ctrl-Y pour copier'";
        };
      };
    };
  };
}
