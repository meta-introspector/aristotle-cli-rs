import Split.Nat_hasNotBit
import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.Nat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.List_ctorIdx
import Split.Nat_casesOn

-- List.get?Internal.match_1 from environment
-- def List.get?Internal.match_1 : forall {α : Type.{u_1}} (motive : (List.{u_1} α) -> Nat -> Sort.{u_2}) (x._@.Init.GetElem.4136898559._hygCtx.12.Init.GetElem.4136898559._hygCtx._hyg.31 : List.{u_1} α) (x._@.Init.GetElem.4136898559._hygCtx.13.Init.GetElem.4136898559._hygCtx._hyg.34 : Nat), (forall (a : α) (tail._@.Init.GetElem.4136898559._hygCtx._hyg.48 : List.{u_1} α), motive (List.cons.{u_1} α a tail._@.Init.GetElem.4136898559._hygCtx._hyg.48) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall (head._@.Init.GetElem.4136898559._hygCtx._hyg.67 : α) (as : List.{u_1} α) (n : Nat), motive (List.cons.{u_1} α head._@.Init.GetElem.4136898559._hygCtx._hyg.67 as) (Nat.succ n)) -> (forall (x._@.Init.GetElem.4136898559._hygCtx._hyg.80 : List.{u_1} α) (x._@.Init.GetElem.4136898559._hygCtx._hyg.79 : Nat), motive x._@.Init.GetElem.4136898559._hygCtx._hyg.80 x._@.Init.GetElem.4136898559._hygCtx._hyg.79) -> (motive x._@.Init.GetElem.4136898559._hygCtx.12.Init.GetElem.4136898559._hygCtx._hyg.31 x._@.Init.GetElem.4136898559._hygCtx.13.Init.GetElem.4136898559._hygCtx._hyg.34)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.get?Internal.match_1`.
-- In a full split, the body would be extracted from the environment.
