{
  description = "Lean declaration: iff_def";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    iff_iff_implies_and_implies.url = "path:/tmp/mathlib-split-test/iff_iff_implies_and_implies";
    And.url = "path:/tmp/mathlib-split-test/And";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-iff_def";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp iff_def.lean $out/
        '';
      };
    };
}