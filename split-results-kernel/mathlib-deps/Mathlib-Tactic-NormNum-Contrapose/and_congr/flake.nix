{
  description = "Lean declaration: and_congr";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Iff-mpr.url = "path:/tmp/mathlib-split-test/Iff/mpr";
    And-imp.url = "path:/tmp/mathlib-split-test/And/imp";
    And.url = "path:/tmp/mathlib-split-test/And";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    Iff-intro.url = "path:/tmp/mathlib-split-test/Iff/intro";
    Iff-mp.url = "path:/tmp/mathlib-split-test/Iff/mp";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-and_congr";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp and_congr.lean $out/
        '';
      };
    };
}