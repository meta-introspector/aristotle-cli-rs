{
  description = "Lean declaration: UnifiedIPLDMemory.instReprTaggedBlock";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    UnifiedIPLDMemory-instReprTaggedBlock-repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/instReprTaggedBlock/repr";
    UnifiedIPLDMemory-TaggedBlock.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/UnifiedIPLDMemory/TaggedBlock";
    Repr-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Repr/mk";
    Repr.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UnifiedIPLDMemory/Repr";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UnifiedIPLDMemory.instReprTaggedBlock";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UnifiedIPLDMemory/instReprTaggedBlock.lean $out/
        '';
      };
    };
}