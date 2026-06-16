{
  description = "Lean declaration: ContentAddressing.asciiSum_recoverable";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    HMul-hMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/HMul/hMul";
    String.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/String";
    Nat-instMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat/instMod";
    instHMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instHMod";
    instMulNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instMulNat";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instOfNatNat";
    HMod-hMod.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/HMod/hMod";
    ContentAddressing-asciiSum.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/asciiSum";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    LT-lt.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/LT/lt";
    Decidable-byContradiction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable/byContradiction";
    ContentAddressing-HashFunction-apply.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/ContentAddressing/HashFunction/apply";
    instDecidableEqNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instDecidableEqNat";
    instLTNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instLTNat";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/OfNat/ofNat";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Not";
    instHMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instHMul";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-ContentAddressing.asciiSum_recoverable";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp ContentAddressing/asciiSum_recoverable.lean $out/
        '';
      };
    };
}