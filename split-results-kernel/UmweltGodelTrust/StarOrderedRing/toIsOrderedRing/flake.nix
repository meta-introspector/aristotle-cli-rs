{
  description = "Lean declaration: StarOrderedRing.toIsOrderedRing";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    NonAssocSemiring-toAddCommMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonAssocSemiring/toAddCommMonoidWithOne";
    IsOrderedModule-toPosSMulMono.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsOrderedModule/toPosSMulMono";
    smul_le_smul_of_nonneg_right.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/smul_le_smul_of_nonneg_right";
    Semiring-toModule.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring/toModule";
    IsOrderedRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsOrderedRing";
    CommSemiring-toNonUnitalCommSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CommSemiring/toNonUnitalCommSemiring";
    CommSemiring-toSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CommSemiring/toSemiring";
    instDistribSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/instDistribSMul";
    IsOrderedModule-toSMulPosMono.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsOrderedModule/toSMulPosMono";
    AddMonoid-toAddZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddMonoid/toAddZeroClass";
    PartialOrder-toPreorder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/PartialOrder/toPreorder";
    instIsOrderedModule.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/instIsOrderedModule";
    StarMul-toStarModule.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarMul/toStarModule";
    NonUnitalNonAssocSemiring-toMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalNonAssocSemiring/toMulZeroClass";
    Preorder-toLE.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Preorder/toLE";
    IsOrderedRing-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsOrderedRing/mk";
    AddZeroClass-toAddZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddZeroClass/toAddZero";
    PartialOrder.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/PartialOrder";
    DistribSMul-toSMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/DistribSMul/toSMulZeroClass";
    NonUnitalSemiring-toNonUnitalNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalSemiring/toNonUnitalNonAssocSemiring";
    AddCommMonoidWithOne-toAddMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddCommMonoidWithOne/toAddMonoidWithOne";
    LE-le.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/LE/le";
    IsScalarTower-left.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/IsScalarTower/left";
    smulCommClass_self.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/smulCommClass_self";
    NonUnitalCommSemiring-toNonUnitalSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalCommSemiring/toNonUnitalSemiring";
    CommSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CommSemiring";
    NonUnitalNonAssocSemiring-toAddCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalNonAssocSemiring/toAddCommMonoid";
    AddZero-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddZero/toZero";
    PosMulMono-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/PosMulMono/mk";
    instZeroLEOneClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/instZeroLEOneClass";
    StarOrderedRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarOrderedRing";
    Distrib-toMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Distrib/toMul";
    CommMonoid-toMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CommMonoid/toMonoid";
    StarRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarRing";
    NonAssocSemiring-toNonUnitalNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonAssocSemiring/toNonUnitalNonAssocSemiring";
    MulPosMono-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MulPosMono/mk";
    CommSemiring-toCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/CommSemiring/toCommMonoid";
    Semiring-toNonUnitalSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring/toNonUnitalSemiring";
    NonUnitalNonAssocSemiring-toDistrib.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/NonUnitalNonAssocSemiring/toDistrib";
    Zero-toOfNat0.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Zero/toOfNat0";
    Module-toDistribMulAction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Module/toDistribMulAction";
    SMulZeroClass-toSMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/SMulZeroClass/toSMul";
    StarRing-toStarMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarRing/toStarMul";
    AddCommMonoid-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddCommMonoid/toAddMonoid";
    AddMonoidWithOne-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/AddMonoidWithOne/toAddMonoid";
    OfNat-ofNat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/OfNat/ofNat";
    Semiring-toNonAssocSemiring.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring/toNonAssocSemiring";
    StarOrderedRing-toIsOrderedAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/StarOrderedRing/toIsOrderedAddMonoid";
    MonoidWithZero-toMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MonoidWithZero/toMonoid";
    MulZeroClass-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/MulZeroClass/toZero";
    DistribMulAction-toMulAction.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/DistribMulAction/toMulAction";
    smul_le_smul_of_nonneg_left.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/smul_le_smul_of_nonneg_left";
    Semiring-toMonoidWithZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/UmweltGodelTrust/Semiring/toMonoidWithZero";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-StarOrderedRing.toIsOrderedRing";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp StarOrderedRing/toIsOrderedRing.lean $out/
        '';
      };
    };
}