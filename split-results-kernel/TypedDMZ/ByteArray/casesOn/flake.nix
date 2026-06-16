{
  description = "Lean declaration: ByteArray.casesOn";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    ByteArray-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ByteArray/mk";
    Array.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Array";
    ByteArray-rec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ByteArray/rec";
    ByteArray.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/ByteArray";
    UInt8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/UInt8";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ByteArray.casesOn";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ByteArray/casesOn.lean $out/
        '';
      };
    };
}