{
  description = "Lean declaration: PadicEntropyDAG.DagLayers.mk.inj";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    PadicEntropyDAG-DagLayers-mk-noConfusion.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/DagLayers/mk/noConfusion";
    Array.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Array";
    PadicEntropyDAG-IrrepNode.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/IrrepNode";
    And.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/And";
    PadicEntropyDAG-RootConfig.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/RootConfig";
    And-intro.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/And/intro";
    PadicEntropyDAG-DagLayers-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/DagLayers/mk";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Eq";
    PadicEntropyDAG-DagLayers.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/PadicEntropyDAG/DagLayers";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-PadicEntropyDAG.DagLayers.mk.inj";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp PadicEntropyDAG/DagLayers/mk/inj.lean $out/
        '';
      };
    };
}