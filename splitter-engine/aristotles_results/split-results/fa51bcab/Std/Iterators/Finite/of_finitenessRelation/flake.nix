{
  description = "Lean declaration: Std.Iterators.Finite.of_finitenessRelation";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-Iterators-FinitenessRelation.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterators/FinitenessRelation";
    Std-Iterators-Finite.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterators/Finite";
    Std-Iterators-FinitenessRelation-wf.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterators/FinitenessRelation/wf";
    Std-Iterators-FinitenessRelation-subrelation.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterators/FinitenessRelation/subrelation";
    Std-Iterator.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterator";
    Std-IterM-IsPlausibleSuccessorOf.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/IterM/IsPlausibleSuccessorOf";
    Subrelation-wf.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Subrelation/wf";
    Std-Iterators-Finite-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterators/Finite/mk";
    Std-Iterators-FinitenessRelation-Rel.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterators/FinitenessRelation/Rel";
    Std-IterM.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/IterM";
    InvImage-wf.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/InvImage/wf";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.Iterators.Finite.of_finitenessRelation";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/Iterators/Finite/of_finitenessRelation.lean $out/
        '';
      };
    };
}