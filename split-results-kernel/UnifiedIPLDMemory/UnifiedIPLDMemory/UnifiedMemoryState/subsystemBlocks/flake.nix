{
  description = "Lean declaration: UnifiedIPLDMemory.UnifiedMemoryState.subsystemBlocks";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    UnifiedIPLDMemory-TaggedBlock.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/TaggedBlock";
    UnifiedIPLDMemory-UnifiedMemoryState.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/UnifiedMemoryState";
    instBEqOfDecidableEq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/instBEqOfDecidableEq";
    UnifiedIPLDMemory-TaggedBlock-origin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/TaggedBlock/origin";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/List";
    BEq-beq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/BEq/beq";
    UnifiedIPLDMemory-instDecidableEqMemorySubsystem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/instDecidableEqMemorySubsystem";
    List-filter.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/List/filter";
    UnifiedIPLDMemory-UnifiedMemoryState-taggedBlocks.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/UnifiedMemoryState/taggedBlocks";
    UnifiedIPLDMemory-MemorySubsystem.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/MemorySubsystem";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UnifiedIPLDMemory.UnifiedMemoryState.subsystemBlocks";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UnifiedIPLDMemory/UnifiedMemoryState/subsystemBlocks.lean $out/
        '';
      };
    };
}