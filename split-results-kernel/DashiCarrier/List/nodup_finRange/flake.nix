{
  description = "Lean declaration: List.nodup_finRange";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-Pairwise-pmap.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/Pairwise/pmap";
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq/mpr";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/congrArg";
    Fin-ne_of_val_ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin/ne_of_val_ne";
    Fin-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin/mk";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/id";
    Ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Ne";
    List-range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/range";
    List-Nodup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/Nodup";
    List-pmap.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/pmap";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List";
    List-nodup_range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/nodup_range";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/LT/lt";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/instLTNat";
    List-finRange_eq_pmap_range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/finRange_eq_pmap_range";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Fin";
    List-finRange.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/List/finRange";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/DashiCarrier/Eq";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-List.nodup_finRange";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp List/nodup_finRange.lean $out/
        '';
      };
    };
}