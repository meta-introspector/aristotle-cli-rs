{
  description = "Lean declaration: imp_not_comm";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/tmp/mathlib-split-test/False";
    Iff.url = "path:/tmp/mathlib-split-test/Iff";
    imp-swap.url = "path:/tmp/mathlib-split-test/imp/swap";
    Not.url = "path:/tmp/mathlib-split-test/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-imp_not_comm";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp imp_not_comm.lean $out/
        '';
      };
    };
}