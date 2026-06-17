import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.Array
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_zero
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Array_size
import Split.Nat_casesOn

-- Array.forIn'.loop.match_3 from environment
-- def Array.forIn'.loop.match_3 : forall {α : Type.{u_1}} (as : Array.{u_1} α) (motive : forall (i._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.71 : Nat), (LE.le.{0} Nat instLENat i._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.71 (Array.size.{u_1} α as)) -> Sort.{u_2}) (i._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.71 : Nat) (h._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.73 : LE.le.{0} Nat instLENat i._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.71 (Array.size.{u_1} α as)), (forall (x._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.80 : LE.le.{0} Nat instLENat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.size.{u_1} α as)), motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.80) -> (forall (i : Nat) (h : LE.le.{0} Nat instLENat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) (Array.size.{u_1} α as)), motive (Nat.succ i) h) -> (motive i._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.71 h._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.73)
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.forIn'.loop.match_3`.
-- In a full split, the body would be extracted from the environment.
