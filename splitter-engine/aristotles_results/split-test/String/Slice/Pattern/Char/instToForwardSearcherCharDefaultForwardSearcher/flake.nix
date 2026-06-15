{
  description = "Lean declaration: String.Slice.Pattern.Char.instToForwardSearcherCharDefaultForwardSearcher";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String-Slice-Pattern-ToForwardSearcher.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/ToForwardSearcher";
    String-Slice-Pattern-ToForwardSearcher-DefaultForwardSearcher.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/ToForwardSearcher/DefaultForwardSearcher";
    Char.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/Char";
    String-Slice-Pattern-Char-instForwardPatternChar.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/Char/instForwardPatternChar";
    String-Slice-Pattern-ToForwardSearcher-defaultImplementation.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pattern/ToForwardSearcher/defaultImplementation";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-String.Slice.Pattern.Char.instToForwardSearcherCharDefaultForwardSearcher";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp String/Slice/Pattern/Char/instToForwardSearcherCharDefaultForwardSearcher.lean $out/
        '';
      };
    };
}