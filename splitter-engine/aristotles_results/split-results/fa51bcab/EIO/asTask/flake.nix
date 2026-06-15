{
  description = "Lean declaration: EIO.asTask";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Task.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Task";
    BaseIO-asTask.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/BaseIO/asTask";
    EIO.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/EIO";
    Task-Priority.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Task/Priority";
    Task-Priority-default.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Task/Priority/default";
    EIO-toBaseIO.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/EIO/toBaseIO";
    optParam.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/optParam";
    Except.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Except";
    BaseIO.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/BaseIO";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-EIO.asTask";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp EIO/asTask.lean $out/
        '';
      };
    };
}