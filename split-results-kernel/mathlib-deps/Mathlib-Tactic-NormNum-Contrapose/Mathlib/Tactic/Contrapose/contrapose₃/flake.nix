{
  description = "Lean declaration: Mathlib.Tactic.Contrapose.contrapose₃";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/tmp/mathlib-split-test/False";
    Iff-mp.url = "path:/tmp/mathlib-split-test/Iff/mp";
    Not.url = "path:/tmp/mathlib-split-test/Not";
    Imp-swap.url = "path:/tmp/mathlib-split-test/Imp/swap";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Mathlib.Tactic.Contrapose.contrapose₃";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Mathlib/Tactic/Contrapose/contrapose₃.lean $out/
        '';
      };
    };
}