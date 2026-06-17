{
  description = "Lean declaration: not_iff_comm";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Classical-propDecidable.url = "path:/tmp/mathlib-split-test/Classical/propDecidable";
    Decidable-not_iff_comm.url = "path:/tmp/mathlib-split-test/Decidable/not_iff_comm";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-not_iff_comm";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp not_iff_comm.lean $out/
        '';
      };
    };
}