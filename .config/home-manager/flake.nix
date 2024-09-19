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
      defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
      defaultPackage.aarch64-darwin = home-manager.defaultPackage.aarch64-darwin;
      formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixpkgs-fmt;
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      homeConfigurations."jeremyp@AppleState" = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-darwin";
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;

        # config goes here
        modules = [ ./home.nix ];
      };
      homeConfigurations."jeremyp@ActivePro" = home-manager.lib.homeManagerConfiguration {
        system = "aarch64-darwin";
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

        # config goes here
        modules = [ ./home.nix ];
      };
    };
}
