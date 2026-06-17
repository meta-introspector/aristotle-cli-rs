{
  description = "Lean declaration: Decidable.not_iff_not";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Eq-mpr.url = "path:/tmp/mathlib-split-test/Eq/mpr";
    congrArg.url = "path:/tmp/mathlib-split-test/congrArg";
    Decidable.url = "path:/tmp/mathlib-split-test/Decidable";
    iff_def.url = "path:/tmp/mathlib-split-test/iff_def";
    id.url = "path:/tmp/mathlib-split-test/id";
    And.url = "path:/tmp/mathlib-split-test/And";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    Decidable-not_imp_not.url = "path:/tmp/mathlib-split-test/Decidable/not_imp_not";
    propext.url = "path:/tmp/mathlib-split-test/propext";
    iff_def'.url = "path:/tmp/mathlib-split-test/iff_def'";
    Eq.url = "path:/tmp/mathlib-split-test/Eq";
    Not.url = "path:/tmp/mathlib-split-test/Not";
    and_congr.url = "path:/tmp/mathlib-split-test/and_congr";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Decidable.not_iff_not";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Decidable/not_iff_not.lean $out/
        '';
      };
    };
}