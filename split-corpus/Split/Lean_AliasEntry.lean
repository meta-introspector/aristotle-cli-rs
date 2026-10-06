import Mathlib

set_option pp.all true
-- spec: Lean.AliasEntry : Type
def Lean.AliasEntry : Type :=
  Prod.{0, 0} Lean.Name Lean.Name
