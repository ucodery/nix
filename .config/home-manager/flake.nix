{
  description = "µcodery config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    {
      # `nix run .config/home-manager -- switch ...` runs the pinned home-manager
      packages.aarch64-darwin.default = home-manager.packages.aarch64-darwin.default;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

      homeConfigurations."jeremyp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

        # config goes here
        modules = [ ./home.nix ];
      };
    };
}
