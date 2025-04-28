{
  description = "Ultimate nix-darwin system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
  let
    configuration = systemPlatform: hostname: { pkgs, ... }: {
      # Let Determinate manage nix itself
      nix.enable = false;
      
      # Allow unfree software to be installed, like Obsidian
      nixpkgs.config.allowUnfree = true;

      networking.hostName = hostname;

      # sudo with Touch ID
      security.pam.services.sudo_local.touchIdAuth = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ git
          git-lfs
          obsidian
          mediainfo
          direnv
          bat
          jq
          tree
        ];

      fonts.packages = with pkgs;
      	[ monaspace
      	];

      environment.variables.HOMEBREW_NO_ANALYTICS = "1";

      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = true;
          cleanup = "zap";
          upgrade = true;
        };

        casks = [
          "Arc"
          "1Password"
          "Raycast"
          "Ghostty"
          "xcodes"
          "MakeMKV"
          "handbrake"
          "Fork"
        ];

        masApps = {
          Ivory = 6444602274;
        };
      };

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = systemPlatform;
    };
    mkHomeConfig = username: {
      users.users.${username}.home = "/Users/${username}";
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ./home.nix; 
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#intel-macbook
    darwinConfigurations."intel-macbook" = nix-darwin.lib.darwinSystem {
      modules =
      	[ (configuration "x86_64-darwin" "Hennings-MacBook-Intel")
          home-manager.darwinModules.home-manager (mkHomeConfig "henning")
      	];
    };
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#m4-macbook
    darwinConfigurations."m4-macbook" = nix-darwin.lib.darwinSystem {
      modules =
      	[ (configuration "aarch64-darwin" "Hennings-MacBook-M4")
          home-manager.darwinModules.home-manager (mkHomeConfig "henning")
      	];
    };
  };
}
