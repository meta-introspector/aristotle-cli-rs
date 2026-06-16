{
  description = "Lean declaration: Fin.instCommSemigroup";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    CommSemigroup-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/CommSemigroup/mk";
    Semigroup-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Semigroup/mk";
    Mul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Mul";
    inferInstance.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/inferInstance";
    Fin-mul_comm.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/mul_comm";
    CommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/CommSemigroup";
    Fin-instMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/instMul";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Fin.instCommSemigroup";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Fin/instCommSemigroup.lean $out/
        '';
      };
    };
}