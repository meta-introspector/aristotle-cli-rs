{
  description = "Lean declaration: Std.Rxo.Iterator.instFinite";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Std-PRange-UpwardEnumerable.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/PRange/UpwardEnumerable";
    Std-Rxo-instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/Rxo/instIteratorIteratorIdOfUpwardEnumerableOfDecidableLT";
    Std-Iterators-Finite.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/Iterators/Finite";
    Std-Rxo-Iterator.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/Rxo/Iterator";
    Id.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Id";
    Std-Rxo-IsAlwaysFinite.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/Rxo/IsAlwaysFinite";
    Std-Iterators-Finite-of_finitenessRelation.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/Iterators/Finite/of_finitenessRelation";
    DecidableLT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/DecidableLT";
    LT.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/LT";
    Std-PRange-LawfulUpwardEnumerable.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Std/PRange/LawfulUpwardEnumerable";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Std.Rxo.Iterator.instFinite";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Std/Rxo/Iterator/instFinite.lean $out/
        '';
      };
    };
}