import Mathlib

set_option pp.all true
-- spec: Lean.Option.name : forall {α : Type}, (Lean.Option α) -> Lean.Name
def Lean.Option.name : forall {α : Type}, (Lean.Option α) -> Lean.Name :=
  fun (α : Type) (self : Lean.Option α) => self.1
