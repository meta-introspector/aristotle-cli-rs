{
  description = "Lean declaration: by_contradiction";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/tmp/mathlib-split-test/False";
    Classical-propDecidable.url = "path:/tmp/mathlib-split-test/Classical/propDecidable";
    Decidable-byContradiction.url = "path:/tmp/mathlib-split-test/Decidable/byContradiction";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-by_contradiction";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp by_contradiction.lean $out/
        '';
      };
    };
}