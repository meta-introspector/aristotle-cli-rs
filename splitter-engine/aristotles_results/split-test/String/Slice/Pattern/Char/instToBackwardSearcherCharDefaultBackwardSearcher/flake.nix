{
  description = "Lean declaration: String.Slice.Pattern.Char.instToBackwardSearcherCharDefaultBackwardSearcher";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String-Slice-Pattern-ToBackwardSearcher-defaultImplementation.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/ToBackwardSearcher/defaultImplementation";
    Char.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Char";
    String-Slice-Pattern-ToBackwardSearcher-DefaultBackwardSearcher.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/ToBackwardSearcher/DefaultBackwardSearcher";
    String-Slice-Pattern-Char-instBackwardPatternChar.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/Char/instBackwardPatternChar";
    String-Slice-Pattern-ToBackwardSearcher.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/ToBackwardSearcher";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-String.Slice.Pattern.Char.instToBackwardSearcherCharDefaultBackwardSearcher";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp String/Slice/Pattern/Char/instToBackwardSearcherCharDefaultBackwardSearcher.lean $out/
        '';
      };
    };
}