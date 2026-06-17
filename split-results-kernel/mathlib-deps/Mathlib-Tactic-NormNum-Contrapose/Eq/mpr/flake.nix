{
  description = "Lean declaration: Eq.mpr";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-rec.url = "path:/tmp/mathlib-split-test/Eq/rec";
    Eq-symm.url = "path:/tmp/mathlib-split-test/Eq/symm";
    Eq.url = "path:/tmp/mathlib-split-test/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Eq.mpr";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Eq/mpr.lean $out/
        '';
      };
    };
}