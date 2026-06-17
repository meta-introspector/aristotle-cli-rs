import Split.of_decide_eq_true
import Split.ZMod_commRing
import Split.instDecidableEqFin
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.FractranCRTMerger_obj_cliff64
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
import Split.FractranCRTMerger_obj_cliff128
import Split.HAdd_hAdd
import Split.Nat
import Split.FractranCRTMerger_bottGradeObj
import Split.LT_lt
import Split.Decidable_byContradiction
import Split.Nat_decLt
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
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

-- FractranCRTMerger.cliff_tower_bott_zero from environment
-- theorem FractranCRTMerger.cliff_tower_bott_zero : And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_bott8) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.72 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bottGrade._proof_3 a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.72)))) (And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff16) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.76 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bottGrade._proof_3 a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.76)))) (And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff32) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.80 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.bottGrade._proof_3 a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.80)))) (And (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff64) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 6 (instOfNatNat 6)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 6 (instOfNatNat 6)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 6 (instOfNatNat 6)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.84 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 6 (instOfNatNat 6)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.cliff_tower_bott_zero._proof_1 a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.84)))) (Eq.{1} (Fin (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (FractranCRTMerger.bottGradeObj FractranCRTMerger.obj_cliff128) (Fin.mk (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (OfNat.ofNat.{0} Nat 5 (instOfNatNat 5)) (Decidable.byContradiction (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 5 (instOfNatNat 5)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (Nat.decLt (OfNat.ofNat.{0} Nat 5 (instOfNatNat 5)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (fun (a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.88 : Not (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 5 (instOfNatNat 5)) (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) => FractranCRTMerger.cliff_tower_bott_zero._proof_2 a._@._internal.0.RequestProject.FractranCRTMerger.2133115124._hygCtx._hyg.88)))))))

-- Stub: this file represents the declaration `FractranCRTMerger.cliff_tower_bott_zero`.
-- In a full split, the body would be extracted from the environment.
