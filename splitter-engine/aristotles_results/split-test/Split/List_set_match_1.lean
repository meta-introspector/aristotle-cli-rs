import Split.instOfNatNat
import Split.List_cons
import Split.List
import Split.Nat
import Split.List_casesOn
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Nat_casesOn
import Split.List_nil

-- List.set.match_1 from environment
-- def List.set.match_1 : forall {α : Type.{u_1}} (motive : (List.{u_1} α) -> Nat -> α -> Sort.{u_2}) (x._@.Init.Prelude.3103831426._hygCtx.14.Init.Prelude.3103831426._hygCtx._hyg.41 : List.{u_1} α) (x._@.Init.Prelude.3103831426._hygCtx.15.Init.Prelude.3103831426._hygCtx._hyg.44 : Nat) (x._@.Init.Prelude.3103831426._hygCtx.16.Init.Prelude.3103831426._hygCtx._hyg.47 : α), (forall (head._@.Init.Prelude.3103831426._hygCtx._hyg.60 : α) (as : List.{u_1} α) (b : α), motive (List.cons.{u_1} α head._@.Init.Prelude.3103831426._hygCtx._hyg.60 as) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) b) -> (forall (a : α) (as : List.{u_1} α) (n : Nat) (b : α), motive (List.cons.{u_1} α a as) (Nat.succ n) b) -> (forall (x._@.Init.Prelude.3103831426._hygCtx._hyg.101 : Nat) (x._@.Init.Prelude.3103831426._hygCtx._hyg.100 : α), motive (List.nil.{u_1} α) x._@.Init.Prelude.3103831426._hygCtx._hyg.101 x._@.Init.Prelude.3103831426._hygCtx._hyg.100) -> (motive x._@.Init.Prelude.3103831426._hygCtx.14.Init.Prelude.3103831426._hygCtx._hyg.41 x._@.Init.Prelude.3103831426._hygCtx.15.Init.Prelude.3103831426._hygCtx._hyg.44 x._@.Init.Prelude.3103831426._hygCtx.16.Init.Prelude.3103831426._hygCtx._hyg.47)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.set.match_1`.
-- In a full split, the body would be extracted from the environment.
