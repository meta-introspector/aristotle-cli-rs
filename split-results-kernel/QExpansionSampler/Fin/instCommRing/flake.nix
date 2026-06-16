{
  description = "Lean declaration: Fin.instCommRing";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; flake-utils.url = "github:numtide/flake-utils"; 
    Fin-instCommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin/instCommSemigroup";
    Ring-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Ring/mk";
    Monoid-npow.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Monoid/npow";
    Nat-instMulZeroClass.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat/instMulZeroClass";
    Semigroup-toMul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Semigroup/toMul";
    CommRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/CommRing";
    Fin-instNonUnitalCommRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin/instNonUnitalCommRing";
    AddCommGroup-toAddGroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddCommGroup/toAddGroup";
    AddCommGroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddCommGroup";
    Fin-instCommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin/instCommMonoid";
    AddMonoidWithOne-toNatCast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoidWithOne/toNatCast";
    Int.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Int";
    NonUnitalCommRing.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/NonUnitalCommRing";
    Fin-instAddMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin/instAddMonoidWithOne";
    NonUnitalNonAssocSemiring-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/NonUnitalNonAssocSemiring/mk";
    SubNegMonoid-toSub.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/SubNegMonoid/toSub";
    AddMonoidWithOne-toOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoidWithOne/toOne";
    CommSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/CommSemigroup";
    SubNegMonoid-zsmul.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/SubNegMonoid/zsmul";
    Fin-addCommGroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin/addCommGroup";
    AddGroup-toSubNegMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddGroup/toSubNegMonoid";
    CommSemigroup-toSemigroup.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/CommSemigroup/toSemigroup";
    CommMonoid-toMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/CommMonoid/toMonoid";
    Nat.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Nat";
    Fin-intCast.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin/intCast";
    SubNegMonoid-toNeg.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/SubNegMonoid/toNeg";
    AddMonoidWithOne-toAddMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoidWithOne/toAddMonoid";
    NonUnitalSemiring-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/NonUnitalSemiring/mk";
    NeZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/NeZero";
    Semiring-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Semiring/mk";
    IntCast-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/IntCast/mk";
    Fin.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/Fin";
    CommMonoid.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/CommMonoid";
    CommRing-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/CommRing/mk";
    AddCommMonoid-mk.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddCommMonoid/mk";
    MulZeroClass-toZero.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/MulZeroClass/toZero";
    AddMonoidWithOne.url = "path:/mnt/data1/time-2026/05-may/07/arist/split-results-kernel/QExpansionSampler/AddMonoidWithOne";
  };
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "decl-Fin.instCommRing";
        version = "0.1.0";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out
          cp Fin/instCommRing.lean $out/
        '';
      };
    };
}