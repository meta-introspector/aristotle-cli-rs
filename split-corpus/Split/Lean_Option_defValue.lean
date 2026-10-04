import Mathlib

set_option pp.all true
-- spec: Lean.Option.defValue : forall {α : Type}, (Lean.Option α) -> α
def Lean.Option.defValue : forall {α : Type}, (Lean.Option α) -> α :=
  fun (α : Type) (self : Lean.Option α) => self.2
