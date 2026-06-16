{
  description = "Lean declaration: Nat.instIsCancelMulZero";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Nat-instMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/instMulZeroClass";
    IsRightCancelMulZero-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsRightCancelMulZero/mk";
    IsCancelMulZero-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsCancelMulZero/mk";
    Nat-eq_of_mul_eq_mul_right.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/eq_of_mul_eq_mul_right";
    IsLeftCancelMulZero-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsLeftCancelMulZero/mk";
    Ne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Ne";
    instMulNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/instMulNat";
    IsCancelMulZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsCancelMulZero";
    Nat-pos_of_ne_zero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/pos_of_ne_zero";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat";
    Zero-toOfNat0.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Zero/toOfNat0";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/OfNat/ofNat";
    Nat-eq_of_mul_eq_mul_left.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Nat/eq_of_mul_eq_mul_left";
    MulZeroClass-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MulZeroClass/toZero";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.instIsCancelMulZero";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/instIsCancelMulZero.lean $out/
        '';
      };
    };
}