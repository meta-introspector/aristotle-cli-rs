{
  description = "Lean declaration: String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.iter";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String-Slice-Pattern-SearchStep.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/String/Slice/Pattern/SearchStep";
    String-Slice.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/String/Slice";
    String-Slice-startPos.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/String/Slice/startPos";
    String-Slice-Pattern-ToForwardSearcher-DefaultForwardSearcher.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/String/Slice/Pattern/ToForwardSearcher/DefaultForwardSearcher";
    String-Slice-Pattern-ToForwardSearcher-DefaultForwardSearcher-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/String/Slice/Pattern/ToForwardSearcher/DefaultForwardSearcher/mk";
    Std-Iter-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iter/mk";
    Std-Iter.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-results/fa51bcab/Std/Iter";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.iter";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp String/Slice/Pattern/ToForwardSearcher/DefaultForwardSearcher/iter.lean $out/
        '';
      };
    };
}