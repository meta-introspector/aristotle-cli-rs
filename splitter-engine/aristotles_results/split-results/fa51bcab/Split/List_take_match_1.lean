import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.Nat
import Split.List_casesOn
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Nat_casesOn
import Split.List_nil

-- List.take.match_1 from environment
-- def List.take.match_1 : forall {α : Type.{u_1}} (motive : Nat -> (List.{u_1} α) -> Sort.{u_2}) (x._@.Init.Data.List.Basic.3220225865._hygCtx.12.Init.Data.List.Basic.3220225865._hygCtx._hyg.31 : Nat) (x._@.Init.Data.List.Basic.3220225865._hygCtx.13.Init.Data.List.Basic.3220225865._hygCtx._hyg.34 : List.{u_1} α), (forall (x._@.Init.Data.List.Basic.3220225865._hygCtx._hyg.44 : List.{u_1} α), motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) x._@.Init.Data.List.Basic.3220225865._hygCtx._hyg.44) -> (forall (n._@.Init.Data.List.Basic.3220225865._hygCtx._hyg.60 : Nat), motive (Nat.succ n._@.Init.Data.List.Basic.3220225865._hygCtx._hyg.60) (List.nil.{u_1} α)) -> (forall (n : Nat) (a : α) (as : List.{u_1} α), motive (Nat.succ n) (List.cons.{u_1} α a as)) -> (motive x._@.Init.Data.List.Basic.3220225865._hygCtx.12.Init.Data.List.Basic.3220225865._hygCtx._hyg.31 x._@.Init.Data.List.Basic.3220225865._hygCtx.13.Init.Data.List.Basic.3220225865._hygCtx._hyg.34)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.take.match_1`.
-- In a full split, the body would be extracted from the environment.
