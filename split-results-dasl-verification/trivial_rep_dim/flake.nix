{
  description = "Declaration: trivial_rep_dim";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mathlib.url = "github:leanprover-community/mathlib4/v4.28.0";
    mathlib.flake = false;
  };
  outputs = { self, nixpkgs, flake-utils, mathlib }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "decl-trivial_rep_dim";
          version = "0.1.0";
          src = ./.;
          buildInputs = [ mathlib ];
          phases = [ "unpackPhase" "installPhase" ];
          installPhase = ''
            mkdir -p $out
            cp trivial_rep_dim.lean $out/
          '';
        };
      });
}