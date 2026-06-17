import Split.Eq_propIntro
import Split.Lean_injEq_helper
import Split.List_cons
import Split.List
import Split.And
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq
import Split.List_cons_inj

-- List.cons.injEq from environment
-- theorem List.cons.injEq : forall {α : Type.{u}} (head : α) (tail : List.{u} α) (head_1 : α) (tail_1 : List.{u} α), Eq.{1} Prop (Eq.{succ u} (List.{u} α) (List.cons.{u} α head tail) (List.cons.{u} α head_1 tail_1)) (And (Eq.{succ u} α head head_1) (Eq.{succ u} (List.{u} α) tail tail_1))

-- Stub: this file represents the declaration `List.cons.injEq`.
-- In a full split, the body would be extracted from the environment.
