{
  description = "Lean declaration: Nat.instMonoidWithZero";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Monoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Monoid";
    SemigroupWithZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/SemigroupWithZero";
    Nat-instMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat/instMulZeroClass";
    Nat-instSemigroupWithZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat/instSemigroupWithZero";
    Nat-instMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat/instMonoid";
    MulZeroClass-zero_mul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MulZeroClass/zero_mul";
    MulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MulZeroClass";
    MulZeroClass-mul_zero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MulZeroClass/mul_zero";
    MonoidWithZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonoidWithZero";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/Nat";
    MulZeroClass-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MulZeroClass/toZero";
    MonoidWithZero-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/MonsterCarriageTrain/MonoidWithZero/mk";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Nat.instMonoidWithZero";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Nat/instMonoidWithZero.lean $out/
        '';
      };
    };
}