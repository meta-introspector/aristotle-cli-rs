{
  description = "Lean declaration: Decidable.not_imp_symm";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/tmp/mathlib-split-test/False";
    Decidable.url = "path:/tmp/mathlib-split-test/Decidable";
    Function-comp.url = "path:/tmp/mathlib-split-test/Function/comp";
    Decidable-byContradiction.url = "path:/tmp/mathlib-split-test/Decidable/byContradiction";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Decidable.not_imp_symm";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Decidable/not_imp_symm.lean $out/
        '';
      };
    };
}