import Split.Lean_RArray_leaf
import Split.Lean_RArray_branch
import Split.Lean_RArray
import Split.Nat

-- Lean.RArray.rec from environment
-- recursor Lean.RArray.rec : forall {α : Type.{u}} {motive : (Lean.RArray.{u} α) -> Sort.{u_1}}, (forall (a._@._internal._hyg.0 : α), motive (Lean.RArray.leaf.{u} α a._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : Nat) (a_1._@._internal._hyg.0 : Lean.RArray.{u} α) (a_2._@._internal._hyg.0 : Lean.RArray.{u} α), (motive a_1._@._internal._hyg.0) -> (motive a_2._@._internal._hyg.0) -> (motive (Lean.RArray.branch.{u} α a._@._internal._hyg.0 a_1._@._internal._hyg.0 a_2._@._internal._hyg.0))) -> (forall (t : Lean.RArray.{u} α), motive t)

-- Stub: this file represents the declaration `Lean.RArray.rec`.
-- In a full split, the body would be extracted from the environment.
