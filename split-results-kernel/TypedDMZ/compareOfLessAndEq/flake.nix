{
  description = "Lean declaration: compareOfLessAndEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Ordering-gt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Ordering/gt";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable";
    Ordering.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Ordering";
    Ordering-eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Ordering/eq";
    Ordering-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Ordering/lt";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LT/lt";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    LT.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/LT";
    DecidableEq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/DecidableEq";
    ite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ite";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-compareOfLessAndEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp compareOfLessAndEq.lean $out/
        '';
      };
    };
}