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
    let
      system = "x86_64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
      formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixpkgs-fmt;
      homeConfigurations."jeremyp" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # config goes here
        modules = [ ./home.nix ];
      };
    };
}
