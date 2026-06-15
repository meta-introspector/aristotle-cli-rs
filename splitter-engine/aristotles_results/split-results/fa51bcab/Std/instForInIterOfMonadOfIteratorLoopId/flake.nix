{
  description = "Lean declaration: Std.instForInIterOfMonadOfIteratorLoopId";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-Iter-instForIn'.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iter/instForIn'";
    instForInOfForIn'.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/instForInOfForIn'";
    Std-IteratorLoop.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/IteratorLoop";
    Id.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Id";
    Std-Iterator.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iterator";
    Std-Iter-IsPlausibleIndirectOutput.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iter/IsPlausibleIndirectOutput";
    Std-Iter.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iter";
    ForIn.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/ForIn";
    Membership-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Membership/mk";
    Monad.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Monad";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.instForInIterOfMonadOfIteratorLoopId";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/instForInIterOfMonadOfIteratorLoopId.lean $out/
        '';
      };
    };
}