{
  description = "Lean declaration: ByteArray.size";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ByteArray-size-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/ByteArray/size/match_1";
    Array.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Array";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Nat";
    ByteArray.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/ByteArray";
    UInt8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/UInt8";
    Array-size.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/FractranCRTMerger/Array/size";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ByteArray.size";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ByteArray/size.lean $out/
        '';
      };
    };
}