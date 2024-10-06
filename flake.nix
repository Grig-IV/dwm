{
  description = "Dwm flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
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
        pre-commit = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            clean = {
              enable = true;
              name = "clean object files";
              entry = "${pkgs.gnumake}/bin/make clean";
              pass_filenames = false;
            };
          };
        };
      in {
        packages.default = pkgs.dwm;

        checks = {
          pre-commit-check = pre-commit;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [
              clang-tools
              xorg.libX11
              xorg.libXft
              xorg.libXinerama
              gcc
              bear
            ]
            ++ pre-commit.enabledPackages;

          inherit (pre-commit) shellHook;
        };
      }
    );
}
