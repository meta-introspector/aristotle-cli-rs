{
  description = "Lean declaration: Decidable.not_imp_not";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable.url = "path:/tmp/mathlib-split-test/Decidable";
    mt.url = "path:/tmp/mathlib-split-test/mt";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    Iff-intro.url = "path:/tmp/mathlib-split-test/Iff/intro";
    Decidable-byContradiction.url = "path:/tmp/mathlib-split-test/Decidable/byContradiction";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Decidable.not_imp_not";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Decidable/not_imp_not.lean $out/
        '';
      };
    };
}