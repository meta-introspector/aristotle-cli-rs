{
  description = "Lean declaration: String.Slice.Pos.le_endPos";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    String-instLEPos_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/instLEPos_1";
    String-Slice-Pos-offset.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pos/offset";
    String-Slice-Pos-isValidForSlice.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pos/isValidForSlice";
    String-Slice.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/LE/le";
    String-Slice-endPos.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/endPos";
    String-Pos-Raw-IsValidForSlice-le_rawEndPos.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Pos/Raw/IsValidForSlice/le_rawEndPos";
    String-Slice-Pos.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/String/Slice/Pos";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-String.Slice.Pos.le_endPos";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp String/Slice/Pos/le_endPos.lean $out/
        '';
      };
    };
}