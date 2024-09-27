{
  description = "Dwm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              dwm = prev.dwm.overrideAttrs {
                src = ./.;
              };
            })
          ];
        };
      in {
        packages.dwm = pkgs.dwm;
        defaultPackage = pkgs.dwm;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [xorg.libX11 xorg.libXft xorg.libXinerama gcc bear];
        };
      }
    );
}
