{
  description = "Lean declaration: Std.PRange.instLawfulUpwardEnumerableLTNat";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-PRange-LawfulUpwardEnumerableLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/PRange/LawfulUpwardEnumerableLT";
    inferInstance.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/inferInstance";
    instLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instLENat";
    Std-PRange-instLawfulUpwardEnumerableLENat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/PRange/instLawfulUpwardEnumerableLENat";
    Nat-instLawfulOrderLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat/instLawfulOrderLT";
    Std-PRange-instUpwardEnumerableNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/PRange/instUpwardEnumerableNat";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Nat";
    Std-PRange-instLawfulUpwardEnumerableNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/PRange/instLawfulUpwardEnumerableNat";
    Std-instLawfulUpwardEnumerableLTOfLawfulUpwardEnumerableOfLawfulUpwardEnumerableLEOfLawfulOrderLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/instLawfulUpwardEnumerableLTOfLawfulUpwardEnumerableOfLawfulUpwardEnumerableLEOfLawfulOrderLT";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instLTNat";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.PRange.instLawfulUpwardEnumerableLTNat";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/PRange/instLawfulUpwardEnumerableLTNat.lean $out/
        '';
      };
    };
}