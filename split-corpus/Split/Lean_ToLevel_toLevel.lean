import Mathlib

set_option pp.all true
-- spec: Lean.ToLevel.toLevel : forall [self : Lean.ToLevel.{u}], Lean.Level
def Lean.ToLevel.toLevel : forall [self : Lean.ToLevel.{u}], Lean.Level :=
  fun [self : Lean.ToLevel.{u}] => self.1
