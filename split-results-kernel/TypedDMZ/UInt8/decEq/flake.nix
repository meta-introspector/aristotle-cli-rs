{
  description = "Lean declaration: UInt8.decEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable-isTrue.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable/isTrue";
    UInt8-decEq-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/UInt8/decEq/match_1";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable";
    BitVec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/BitVec";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instOfNatNat";
    instDecidableEqBitVec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/instDecidableEqBitVec";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/dite";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Nat";
    Decidable-isFalse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Decidable/isFalse";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/OfNat/ofNat";
    UInt8-ofBitVec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/UInt8/ofBitVec";
    UInt8.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/UInt8";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/TypedDMZ/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-UInt8.decEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp UInt8/decEq.lean $out/
        '';
      };
    };
}