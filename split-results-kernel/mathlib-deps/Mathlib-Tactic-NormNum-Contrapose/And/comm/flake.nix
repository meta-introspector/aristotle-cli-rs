{
  description = "Lean declaration: And.comm";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    And.url = "path:/tmp/mathlib-split-test/And";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    Iff-intro.url = "path:/tmp/mathlib-split-test/Iff/intro";
    And-symm.url = "path:/tmp/mathlib-split-test/And/symm";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-And.comm";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp And/comm.lean $out/
        '';
      };
    };
}