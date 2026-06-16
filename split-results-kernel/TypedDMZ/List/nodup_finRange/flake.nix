{
  description = "Lean declaration: List.nodup_finRange";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    List-Pairwise-pmap.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Pairwise/pmap";
    Eq-mpr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq/mpr";
    congrArg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/congrArg";
    Fin-ne_of_val_ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/ne_of_val_ne";
    Fin-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin/mk";
    id.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/id";
    Ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Ne";
    List-range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/range";
    List-Nodup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/Nodup";
    List-pmap.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/pmap";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List";
    List-nodup_range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/nodup_range";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LT/lt";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instLTNat";
    List-finRange_eq_pmap_range.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/finRange_eq_pmap_range";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fin";
    List-finRange.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/List/finRange";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
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