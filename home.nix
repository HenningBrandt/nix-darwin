{ config, pkgs, ... }:

{
  home.username = "henning";
  home.homeDirectory = "/Users/henning";
  home.stateVersion = "24.11";
  
  home.file = {
    ".config/nvim/init.lua".source = ./dotfiles/nvim.lua;
    ".config/ghostty/config".source = ./dotfiles/ghostty.config;
    ".config/zsh/plugins/powerlevel10k/p10k.zsh".source = ./dotfiles/p10k.zsh;
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    shellAliases = {
      ls = "ls --color";
      la = "ls -la --color";
      c = "clear";
      switch-intel = "darwin-rebuild switch --flake ~/.config/nix-darwin#intel-macbook";
      switch-m4 = "darwin-rebuild switch --flake ~/.config/nix-darwin#m4-macbook";
    };
    plugins = [
      {
        name = "Powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.20.0";
          sha256 = "ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.35.0";
          sha256 = "GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
        };
      }
    ];
    initContent = ''
      # Source Powerlevel10k prompt configuration
      [[ ! -f ~/.config/zsh/plugins/powerlevel10k/p10k.zsh ]] || source "$HOME/.config/zsh/plugins/powerlevel10k/p10k.zsh"

      # Enable direnv
      eval "$(direnv hook zsh)"
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
    ];
  };
}
