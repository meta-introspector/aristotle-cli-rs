{
  description = "Lean declaration: Fin.instDistrib";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Fin-instCommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/instCommSemigroup";
    Semigroup-toMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Semigroup/toMul";
    AddCommSemigroup-toAddSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddCommSemigroup/toAddSemigroup";
    CommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/CommSemigroup";
    AddSemigroup-toAdd.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddSemigroup/toAdd";
    CommSemigroup-toSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/CommSemigroup/toSemigroup";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    Distrib.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Distrib";
    Fin-addCommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/addCommSemigroup";
    Distrib-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Distrib/mk";
    AddCommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/AddCommSemigroup";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Fin.instDistrib";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Fin/instDistrib.lean $out/
        '';
      };
    };
}