{
  description = "Lean declaration: Semiring.toModule";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    MonoidWithZero-toMulActionWithZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MonoidWithZero/toMulActionWithZero";
    Module-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Module/mk";
    DistribMulAction-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/DistribMulAction/mk";
    NonUnitalNonAssocSemiring-toAddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalNonAssocSemiring/toAddCommMonoid";
    MonoidWithZero-toMulZeroOneClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MonoidWithZero/toMulZeroOneClass";
    NonAssocSemiring-toNonUnitalNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonAssocSemiring/toNonUnitalNonAssocSemiring";
    Semiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring";
    MulActionWithZero-toMulAction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MulActionWithZero/toMulAction";
    AddCommMonoid-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddCommMonoid/toAddMonoid";
    MulZeroOneClass-toMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MulZeroOneClass/toMulZeroClass";
    Module.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Module";
    Semiring-toNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring/toNonAssocSemiring";
    MonoidWithZero-toMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MonoidWithZero/toMonoid";
    MulZeroClass-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MulZeroClass/toZero";
    Semiring-toMonoidWithZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring/toMonoidWithZero";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Semiring.toModule";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Semiring/toModule.lean $out/
        '';
      };
    };
}