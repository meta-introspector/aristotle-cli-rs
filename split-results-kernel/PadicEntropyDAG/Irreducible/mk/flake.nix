{
  description = "Lean declaration: Irreducible.mk";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Monoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Monoid";
    HMul-hMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/HMul/hMul";
    Monoid-toMulOneClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Monoid/toMulOneClass";
    IsUnit.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/IsUnit";
    Irreducible.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Irreducible";
    MulOne-toMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/MulOne/toMul";
    MulOneClass-toMulOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/MulOneClass/toMulOne";
    Or.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Or";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/Not";
    instHMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/PadicEntropyDAG/instHMul";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Irreducible.mk";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Irreducible/mk.lean $out/
        '';
      };
    };
}