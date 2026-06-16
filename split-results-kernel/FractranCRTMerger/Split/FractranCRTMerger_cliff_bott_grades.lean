import Split.of_decide_eq_true
import Split.ZMod_commRing
import Split.instDecidableEqFin
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Fin_mk
import Split.id
import Split.Nat_instMod
import Split.instHMod
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.FractranCRTMerger_obj_cliff32
import Split.Nat_cast
import Split.ZMod
import Split.Prod_fst
import Split.FractranCRTMerger_obj_bott8
import Split.instHAdd
import Split.HMod_hMod
import Split.And
import Split.HAdd_hAdd
import Split.Nat
import Split.FractranCRTMerger_bottGradeObj
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.Nat_decLt
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.FractranCRTMerger_obj_cliff4
import Split.instLTNat
import Split.instDecidableAnd
import Split.CommRing_toRing
import Split.Prod
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.Prod_snd
import Split.Ring_toAddGroupWithOne
import Split.Not
import Split.FractranCRTMerger_obj_cliff16
import Split.ZMod_val

-- FractranCRTMerger.cliff_bott_grades from environment
-- theorem FractranCRTMerger.cliff_bott_grades : And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff4) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.58 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.cliff_bott_grades._proof_1 a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.58)))) (And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_bott8) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.62 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bottGrade._proof_3 a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.62)))) (And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff16) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.66 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bottGrade._proof_3 a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.66)))) (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff32) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.70 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bottGrade._proof_3 a._@._internal.0.RequestProject.FractranCRTMerger.79340038._hygCtx._hyg.70))))))

-- Stub: this file represents the declaration `FractranCRTMerger.cliff_bott_grades`.
-- In a full split, the body would be extracted from the environment.
