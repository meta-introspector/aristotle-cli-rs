{
  description = "Lean declaration: String.decEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable-isTrue.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Decidable/isTrue";
    ByteArray-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/ByteArray/mk";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/String";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Decidable";
    instDecidableEqUInt8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/instDecidableEqUInt8";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/dite";
    String-decEq-match_3.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/String/decEq/match_3";
    List.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/List";
    instDecidableEqList.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/instDecidableEqList";
    Decidable-isFalse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Decidable/isFalse";
    Array-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Array/mk";
    String-decEq-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/String/decEq/match_1";
    UInt8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/UInt8";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Eq";
    String-ofByteArray.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/String/ofByteArray";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Not";
    ByteArray-IsValidUTF8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/ByteArray/IsValidUTF8";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-String.decEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp String/decEq.lean $out/
        '';
      };
    };
}