{
  description = "Lean declaration: Mathlib.Tactic.Contrapose.contrapose_iff₂";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    iff_not_comm.url = "path:/tmp/mathlib-split-test/iff_not_comm";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    Iff-mp.url = "path:/tmp/mathlib-split-test/Iff/mp";
    Iff-trans.url = "path:/tmp/mathlib-split-test/Iff/trans";
    Iff-comm.url = "path:/tmp/mathlib-split-test/Iff/comm";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Mathlib.Tactic.Contrapose.contrapose_iff₂";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Mathlib/Tactic/Contrapose/contrapose_iff₂.lean $out/
        '';
      };
    };
}