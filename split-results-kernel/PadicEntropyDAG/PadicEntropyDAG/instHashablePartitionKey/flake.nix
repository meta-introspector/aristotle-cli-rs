{
  description = "Lean declaration: PadicEntropyDAG.instHashablePartitionKey";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    PadicEntropyDAG-instHashablePartitionKey-hash.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/instHashablePartitionKey/hash";
    Hashable-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Hashable/mk";
    Hashable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Hashable";
    PadicEntropyDAG-PartitionKey.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/PartitionKey";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-PadicEntropyDAG.instHashablePartitionKey";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp PadicEntropyDAG/instHashablePartitionKey.lean $out/
        '';
      };
    };
}