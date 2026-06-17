{
  description = "Lean declaration: iff_iff_implies_and_implies";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Iff-mpr.url = "path:/tmp/mathlib-split-test/Iff/mpr";
    And.url = "path:/tmp/mathlib-split-test/And";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    And-right.url = "path:/tmp/mathlib-split-test/And/right";
    And-left.url = "path:/tmp/mathlib-split-test/And/left";
    And-intro.url = "path:/tmp/mathlib-split-test/And/intro";
    Iff-intro.url = "path:/tmp/mathlib-split-test/Iff/intro";
    Iff-mp.url = "path:/tmp/mathlib-split-test/Iff/mp";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-iff_iff_implies_and_implies";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp iff_iff_implies_and_implies.lean $out/
        '';
      };
    };
}