{
  description = "Lean declaration: Mathlib.Tactic.Contrapose.contrapose.negate_iff";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Inhabited-default.url = "path:/tmp/mathlib-split-test/Inhabited/default";
    instInhabitedBool.url = "path:/tmp/mathlib-split-test/instInhabitedBool";
    Lean-Option.url = "path:/tmp/mathlib-split-test/Lean/Option";
    Lean-instInhabitedOption.url = "path:/tmp/mathlib-split-test/Lean/instInhabitedOption";
    Bool.url = "path:/tmp/mathlib-split-test/Bool";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Mathlib.Tactic.Contrapose.contrapose.negate_iff";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Mathlib/Tactic/Contrapose/contrapose/negate_iff.lean $out/
        '';
      };
    };
}