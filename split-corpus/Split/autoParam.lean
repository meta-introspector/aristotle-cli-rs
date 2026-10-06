import Mathlib

set_option pp.all true
-- spec: autoParam : Sort.{u} -> Lean.Syntax -> Sort.{u}
def autoParam : Sort.{u} -> Lean.Syntax -> Sort.{u} :=
  fun (α : Sort.{u}) (tactic : Lean.Syntax) => α
