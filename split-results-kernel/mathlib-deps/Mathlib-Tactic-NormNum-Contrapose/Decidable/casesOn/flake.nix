{
  description = "Lean declaration: Decidable.casesOn";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable-isTrue.url = "path:/tmp/mathlib-split-test/Decidable/isTrue";
    Decidable.url = "path:/tmp/mathlib-split-test/Decidable";
    Decidable-rec.url = "path:/tmp/mathlib-split-test/Decidable/rec";
    Decidable-isFalse.url = "path:/tmp/mathlib-split-test/Decidable/isFalse";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Decidable.casesOn";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Decidable/casesOn.lean $out/
        '';
      };
    };
}