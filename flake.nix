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
    configuration = systemPlatform: { pkgs, ... }: {
      # Let Determinate manage nix itself
      nix.enable = false;
      
      # Allow unfree software to be installed, like Obsidian
      nixpkgs.config.allowUnfree = true;

      networking.hostName = "Hennings-Intel-MacBook-Pro";

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ git
          git-lfs
          obsidian
          mediainfo
          direnv
          bat
          alacritty
          jq
          tree
        ];

      fonts.packages = with pkgs;
      	[ monaspace
      	];

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
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#personal-macbook
    darwinConfigurations."personal-macbook" = nix-darwin.lib.darwinSystem {
      modules =
      	[ (configuration "x86_64-darwin")
          home-manager.darwinModules.home-manager {
            users.users.henning.home = "/Users/henning";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.henning = import ./home.nix;
          }
      	];
    };
  };
}
