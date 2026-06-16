import Split.instOfNatNat
import Split.Array
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Nat_zero
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Array_size
import Split.Nat_casesOn

-- Array.mapFinIdxM.map.match_1 from environment
-- def Array.mapFinIdxM.map.match_1 : forall {α : Type.{u_1}} (as : Array.{u_1} α) (j : Nat) (motive : forall (i._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.71 : Nat), (Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.71 j) (Array.size.{u_1} α as)) -> Sort.{u_2}) (i._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.71 : Nat) (inv._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.73 : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.71 j) (Array.size.{u_1} α as)), (forall (x._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.80 : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) j) (Array.size.{u_1} α as)), motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.80) -> (forall (i : Nat) (inv : Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) j) (Array.size.{u_1} α as)), motive (Nat.succ i) inv) -> (motive i._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.71 inv._@.Init.Data.Array.Basic.862946261._hygCtx._hyg.73)
-- (definition body omitted)

-- Stub: this file represents the declaration `Array.mapFinIdxM.map.match_1`.
-- In a full split, the body would be extracted from the environment.
