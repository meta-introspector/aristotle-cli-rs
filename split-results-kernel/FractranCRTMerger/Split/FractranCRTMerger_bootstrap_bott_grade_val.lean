import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CommRing_toNonUnitalCommRing
import Split.of_decide_eq_true
import Split.ZMod_commRing
import Split.instDecidableEqFin
import Split.Nat_instAtLeastTwoHAddOfNat
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Fin_mk
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.Prod_mk
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.ZMod
import Split.Nat_instNeZeroSucc
import Split.Nat
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.Nat_decLt
import Split.Zero_toOfNat0
import Split.FractranCRTMerger_bottGrade
import Split.instLTNat
import Split.CommRing_toRing
import Split.Prod
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.Ring_toAddGroupWithOne
import Split.instOfNatAtLeastTwo
import Split.Not
import Split.MulZeroClass_toZero

-- FractranCRTMerger.bootstrap_bott_grade_val from environment
-- theorem FractranCRTMerger.bootstrap_bott_grade_val : Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGrade (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) (OfNat.ofNat.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) 40 (instOfNatAtLeastTwo.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) 40 (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 39 (instOfNatNat 39)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 38 (instOfNatNat 38)))))) (Prod.mk.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (OfNat.ofNat.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) 42 (instOfNatAtLeastTwo.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) 42 (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 41 (instOfNatNat 41)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 40 (instOfNatNat 40)))))) (OfNat.ofNat.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) 0 (Zero.toOfNat0.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (MulZeroClass.toZero.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalNonAssocSemiring.toMulZeroClass.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toNonUnitalCommRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))))))))))))) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.4085693572._hygCtx._hyg.34 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bootstrap_bott_grade._proof_1 a._@._internal.0.RequestProject.FractranCRTMerger.4085693572._hygCtx._hyg.34)))

-- Stub: this file represents the declaration `FractranCRTMerger.bootstrap_bott_grade_val`.
-- In a full split, the body would be extracted from the environment.
