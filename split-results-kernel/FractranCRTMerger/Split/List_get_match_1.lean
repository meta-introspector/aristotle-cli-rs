import Split.False
import Split.Fin_casesOn
import Split.HEq_refl
import Split.False_elim
import Split.noConfusion_of_Nat
import Split.Fin_mk
import Split.instOfNatNat
import Split.Nat_le_step
import Split.List_cons
import Split.List
import Split.Nat_le
import Split.Nat
import Split.LT_lt
import Split.List_casesOn
import Split.Nat_ctorIdx
import Split.Nat_zero
import Split.Eq_refl
import Split.HEq
import Split.Nat_le_refl
import Split.instLTNat
import Split.Nat_le_casesOn
import Split.OfNat_ofNat
import Split.Fin
import Split.Nat_succ
import Split.Eq
import Split.List_length
import Split.Nat_casesOn
import Split.List_nil

-- List.get.match_1 from environment
-- def List.get.match_1 : forall {α : Type.{u_1}} (motive : forall (x._@.Init.Prelude.1017806716._hygCtx.10.Init.Prelude.1017806716._hygCtx._hyg.29 : List.{u_1} α), (Fin (List.length.{u_1} α x._@.Init.Prelude.1017806716._hygCtx.10.Init.Prelude.1017806716._hygCtx._hyg.29)) -> Sort.{u_2}) (x._@.Init.Prelude.1017806716._hygCtx.10.Init.Prelude.1017806716._hygCtx._hyg.29 : List.{u_1} α) (x._@.Init.Prelude.1017806716._hygCtx.11.Init.Prelude.1017806716._hygCtx._hyg.32 : Fin (List.length.{u_1} α x._@.Init.Prelude.1017806716._hygCtx.10.Init.Prelude.1017806716._hygCtx._hyg.29)), (forall (a : α) (tail._@.Init.Prelude.1017806716._hygCtx._hyg.50 : List.{u_1} α) (isLt._@.Init.Prelude.1017806716._hygCtx._hyg.49 : LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (List.length.{u_1} α (List.cons.{u_1} α a tail._@.Init.Prelude.1017806716._hygCtx._hyg.50))), motive (List.cons.{u_1} α a tail._@.Init.Prelude.1017806716._hygCtx._hyg.50) (Fin.mk (List.length.{u_1} α (List.cons.{u_1} α a ([mdata _inaccessible:1 tail._@.Init.Prelude.1017806716._hygCtx._hyg.50]))) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) isLt._@.Init.Prelude.1017806716._hygCtx._hyg.49)) -> (forall (head._@.Init.Prelude.1017806716._hygCtx._hyg.71 : α) (as : List.{u_1} α) (i : Nat) (h : LT.lt.{0} Nat instLTNat (Nat.succ i) (List.length.{u_1} α (List.cons.{u_1} α head._@.Init.Prelude.1017806716._hygCtx._hyg.71 as))), motive (List.cons.{u_1} α head._@.Init.Prelude.1017806716._hygCtx._hyg.71 as) (Fin.mk (List.length.{u_1} α (List.cons.{u_1} α ([mdata _inaccessible:1 head._@.Init.Prelude.1017806716._hygCtx._hyg.71]) as)) (Nat.succ i) h)) -> (motive x._@.Init.Prelude.1017806716._hygCtx.10.Init.Prelude.1017806716._hygCtx._hyg.29 x._@.Init.Prelude.1017806716._hygCtx.11.Init.Prelude.1017806716._hygCtx._hyg.32)
-- (definition body omitted)

-- Stub: this file represents the declaration `List.get.match_1`.
-- In a full split, the body would be extracted from the environment.
