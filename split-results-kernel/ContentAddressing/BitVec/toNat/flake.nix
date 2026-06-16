{
  description = "Lean declaration: BitVec.toNat";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    instPowNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instPowNat";
    BitVec.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/BitVec";
    BitVec-toFin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/BitVec/toFin";
    instOfNatNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instOfNatNat";
    Fin-val.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Fin/val";
    instNatPowNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instNatPowNat";
    HPow-hPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/HPow/hPow";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/Nat";
    instHPow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/instHPow";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/ContentAddressing/OfNat/ofNat";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-BitVec.toNat";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp BitVec/toNat.lean $out/
        '';
      };
    };
}