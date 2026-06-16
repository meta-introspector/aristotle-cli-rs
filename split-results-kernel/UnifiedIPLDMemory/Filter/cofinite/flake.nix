{
  description = "Lean declaration: Filter.cofinite";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Set-Finite-union.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Set/Finite/union";
    Set-finite_empty.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Set/finite_empty";
    Set-Finite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Set/Finite";
    HasSubset-Subset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/HasSubset/Subset";
    Set-Finite-subset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Set/Finite/subset";
    Filter-comk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Filter/comk";
    Filter.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Filter";
    Set-instHasSubset.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Set/instHasSubset";
    Set.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Set";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Filter.cofinite";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Filter/cofinite.lean $out/
        '';
      };
    };
}