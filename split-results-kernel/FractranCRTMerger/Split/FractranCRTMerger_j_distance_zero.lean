import Split.Nat_instMulZeroClass
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.HMul_hMul
import Split.CommRing_toNonUnitalCommRing
import Split.ZMod_commRing
import Split.congrArg
import Split.FractranCRTMerger_distanceToJ
import Split.AddMonoid_toAddZeroClass
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Nat_instAddMonoid
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.Prod_mk
import Split.instMulNat
import Split.instOfNatNat
import Split.ZMod_val_zero
import Split.ZMod
import Split.MulZeroClass_mul_zero
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.congr
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.instAddNat
import Split.Zero_toOfNat0
import Split.congrFun'
import Split.Prod
import Split.add_zero
import Split.OfNat_ofNat
import Split.Eq
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.ZMod_val

-- FractranCRTMerger.j_distance_zero from environment
-- theorem FractranCRTMerger.j_distance_zero : Eq.{1} Nat (FractranCRTMerger.distanceToJ (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) (OfNat.ofNat.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) 0 (Zero.toOfNat0.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (MulZeroClass.toZero.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (NonUnitalNonAssocSemiring.toMulZeroClass.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toNonUnitalCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))))))) (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (OfNat.ofNat.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) 0 (Zero.toOfNat0.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (MulZeroClass.toZero.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (NonUnitalNonAssocSemiring.toMulZeroClass.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toNonUnitalCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))))))) (OfNat.ofNat.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) 0 (Zero.toOfNat0.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (MulZeroClass.toZero.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalNonAssocSemiring.toMulZeroClass.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toNonUnitalCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))))))))))))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))

-- Stub: this file represents the declaration `FractranCRTMerger.j_distance_zero`.
-- In a full split, the body would be extracted from the environment.
