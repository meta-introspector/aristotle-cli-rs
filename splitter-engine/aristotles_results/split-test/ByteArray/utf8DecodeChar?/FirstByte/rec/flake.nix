{
  description = "Lean declaration: ByteArray.utf8DecodeChar?.FirstByte.rec";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ByteArray-utf8DecodeChar?-FirstByte-invalid.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/FirstByte/invalid";
    ByteArray-utf8DecodeChar?-FirstByte-threeMore.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/FirstByte/threeMore";
    ByteArray-utf8DecodeChar?-FirstByte-twoMore.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/FirstByte/twoMore";
    ByteArray-utf8DecodeChar?-FirstByte-done.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/FirstByte/done";
    ByteArray-utf8DecodeChar?-FirstByte.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/FirstByte";
    ByteArray-utf8DecodeChar?-FirstByte-oneMore.url = "path:/mnt/data1/time-2026/05-may/07/arist/splitter-engine/aristotles_results/split-test/ByteArray/utf8DecodeChar?/FirstByte/oneMore";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ByteArray.utf8DecodeChar?.FirstByte.rec";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ByteArray/utf8DecodeChar?/FirstByte/rec.lean $out/
        '';
      };
    };
}