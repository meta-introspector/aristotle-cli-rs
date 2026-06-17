{
  description = "Lean declaration: Decidable.byContradiction";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/tmp/mathlib-split-test/False";
    False-elim.url = "path:/tmp/mathlib-split-test/False/elim";
    Decidable.url = "path:/tmp/mathlib-split-test/Decidable";
    id.url = "path:/tmp/mathlib-split-test/id";
    Decidable-byCases.url = "path:/tmp/mathlib-split-test/Decidable/byCases";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Decidable.byContradiction";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Decidable/byContradiction.lean $out/
        '';
      };
    };
}