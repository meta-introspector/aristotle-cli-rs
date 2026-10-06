import Mathlib

set_option pp.all true
-- spec: Nat.lt_wfRel : WellFoundedRelation.{1} Nat
def Nat.lt_wfRel : WellFoundedRelation.{1} Nat :=
  WellFoundedRelation.mk.{1} Nat (fun (x1._@.Init.WF.54674150._hygCtx._hyg.9 : Nat) (x2._@.Init.WF.54674150._hygCtx._hyg.9 : Nat) => LT.lt.{0} Nat instLTNat x1._@.Init.WF.54674150._hygCtx._hyg.9 x2._@.Init.WF.54674150._hygCtx._hyg.9) Nat.lt_wfRel._proof_3
