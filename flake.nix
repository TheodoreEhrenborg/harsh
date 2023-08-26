# Help from
# https://xeiaso.net/blog/nix-flakes-go-programs
{
  description = "A flake for building Hello World";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.utils.url = "github:numtide/flake-utils";
  inputs.gomod2nix = {
    url = "github:tweag/gomod2nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.utils.follows = "utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
    gomod2nix,
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    packages.x86_64-linux.default =
      # Notice the reference to nixpkgs here.
      with import nixpkgs {
        system = "x86_64-linux";
        overlays = [gomod2nix.overlays.default];
      };
        pkgs.buildGoApplication {
          pname = "gomod2nix-example";
          version = "0.1";
          src = ./.;
          modules = ./gomod2nix.toml;
        };
  };
}
