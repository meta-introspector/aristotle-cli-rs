{
  description = "Lean declaration: PadicEntropyDAG.instInhabitedIrrepNode.default";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Inhabited-default.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Inhabited/default";
    PadicEntropyDAG-Metrics.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/Metrics";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/String";
    PadicEntropyDAG-instInhabitedMetrics.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/instInhabitedMetrics";
    Float.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Float";
    Array.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Array";
    PadicEntropyDAG-IrrepNode.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode";
    PadicEntropyDAG-IrrepNode-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode/mk";
    instInhabitedOption.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instInhabitedOption";
    Array-instInhabited.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Array/instInhabited";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Nat";
    Option.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Option";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-PadicEntropyDAG.instInhabitedIrrepNode.default";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp PadicEntropyDAG/instInhabitedIrrepNode/default.lean $out/
        '';
      };
    };
}