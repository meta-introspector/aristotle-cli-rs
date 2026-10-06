import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.auxDeclNGen : Lean.Core.State -> Lean.DeclNameGenerator
def Lean.Core.State.auxDeclNGen : Lean.Core.State -> Lean.DeclNameGenerator :=
  fun (self : Lean.Core.State) => self.4
