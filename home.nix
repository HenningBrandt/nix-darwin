{ config, pkgs, ... }:

{
  home.username = "henning";
  home.homeDirectory = "/Users/henning";
  home.stateVersion = "24.11";
  
  home.file = {
    ".config/nvim/init.lua".source = ./dotfiles/nvim.lua;
    ".config/alacritty.toml".source = ./dotfiles/alacritty.toml;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "ls --color";
      la = "ls -la --color";
      c = "clear";
      switch-personal = "darwin-rebuild switch --flake ~/.config/nix-darwin#personal-macbook";
    };
    initExtra = ''
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
