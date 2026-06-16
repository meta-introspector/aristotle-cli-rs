{
  description = "Lean declaration: BitVec.decEq";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Decidable-isTrue.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable/isTrue";
    instPowNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instPowNat";
    BitVec-ofFin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/BitVec/ofFin";
    instDecidableEqFin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instDecidableEqFin";
    Decidable.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable";
    BitVec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/BitVec";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instOfNatNat";
    dite.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/dite";
    instNatPowNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instNatPowNat";
    HPow-hPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/HPow/hPow";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    BitVec-decEq-match_1.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/BitVec/decEq/match_1";
    instHPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instHPow";
    Decidable-isFalse.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Decidable/isFalse";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/OfNat/ofNat";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Fin";
    Eq.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Eq";
    Not.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Not";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-BitVec.decEq";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp BitVec/decEq.lean $out/
        '';
      };
    };
}