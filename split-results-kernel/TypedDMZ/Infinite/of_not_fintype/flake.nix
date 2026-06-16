{
  description = "Lean declaration: Infinite.of_not_fintype";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    False.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/False";
    IsEmpty.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/IsEmpty";
    IsEmpty-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/IsEmpty/mk";
    Fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Fintype";
    Iff-mp.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Iff/mp";
    Infinite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Infinite";
    isEmpty_fintype.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/isEmpty_fintype";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Infinite.of_not_fintype";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Infinite/of_not_fintype.lean $out/
        '';
      };
    };
}