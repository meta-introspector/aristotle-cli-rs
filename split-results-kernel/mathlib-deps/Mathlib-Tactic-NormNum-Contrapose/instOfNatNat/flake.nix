{
  description = "Lean declaration: instOfNatNat";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Nat.url = "path:/tmp/mathlib-split-test/Nat";
    OfNat-mk.url = "path:/tmp/mathlib-split-test/OfNat/mk";
    OfNat.url = "path:/tmp/mathlib-split-test/OfNat";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-instOfNatNat";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp instOfNatNat.lean $out/
        '';
      };
    };
}