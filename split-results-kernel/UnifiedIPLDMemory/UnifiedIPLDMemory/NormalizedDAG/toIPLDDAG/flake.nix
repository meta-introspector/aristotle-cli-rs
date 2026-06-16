{
  description = "Lean declaration: UnifiedIPLDMemory.NormalizedDAG.toIPLDDAG";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    UnifiedIPLDMemory-NormalizedDAG.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/NormalizedDAG";
    UnifiedIPLDMemory-IPLDDAG.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/IPLDDAG";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UnifiedIPLDMemory.NormalizedDAG.toIPLDDAG";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UnifiedIPLDMemory/NormalizedDAG/toIPLDDAG.lean $out/
        '';
      };
    };
}