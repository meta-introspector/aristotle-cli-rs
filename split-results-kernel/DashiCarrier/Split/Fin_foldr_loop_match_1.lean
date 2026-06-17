import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_zero
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Nat_casesOn

-- Fin.foldr.loop.match_1 from environment
-- def Fin.foldr.loop.match_1 : forall {α : Sort.{u_2}} (n : Nat) (motive : forall (x._@.Init.Data.Fin.Fold.1188276850._hygCtx.29.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.56 : Nat), (LE.le.{0} Nat instLENat x._@.Init.Data.Fin.Fold.1188276850._hygCtx.29.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.56 n) -> α -> Sort.{u_1}) (x._@.Init.Data.Fin.Fold.1188276850._hygCtx.29.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.56 : Nat) (x._@.Init.Data.Fin.Fold.1188276850._hygCtx.30.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.59 : LE.le.{0} Nat instLENat x._@.Init.Data.Fin.Fold.1188276850._hygCtx.29.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.56 n) (x._@.Init.Data.Fin.Fold.1188276850._hygCtx.31.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.62 : α), (forall (x._@.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.71 : LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) (x : α), motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x._@.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.71 x) -> (forall (i : Nat) (h : LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) n) (x : α), motive (Nat.succ i) h x) -> (motive x._@.Init.Data.Fin.Fold.1188276850._hygCtx.29.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.56 x._@.Init.Data.Fin.Fold.1188276850._hygCtx.30.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.59 x._@.Init.Data.Fin.Fold.1188276850._hygCtx.31.Init.Data.Fin.Fold.1188276850._hygCtx._hyg.62)
-- (definition body omitted)

-- Stub: this file represents the declaration `Fin.foldr.loop.match_1`.
-- In a full split, the body would be extracted from the environment.
