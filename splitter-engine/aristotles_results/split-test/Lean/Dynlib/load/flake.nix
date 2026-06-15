{
  description = "Lean declaration: Lean.Dynlib.load";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Inhabited-default.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Inhabited/default";
    instInhabitedError.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/instInhabitedError";
    IO.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/IO";
    instInhabitedEIO.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/instInhabitedEIO";
    IO-Error.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/IO/Error";
    Lean-Dynlib.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Lean/Dynlib";
    System-FilePath.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/System/FilePath";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Lean.Dynlib.load";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Lean/Dynlib/load.lean $out/
        '';
      };
    };
}