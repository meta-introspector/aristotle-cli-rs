import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.OneLine.State.tags : Lean.PrettyPrinter.OneLine.State -> (List.{0} (Prod.{0, 0} Nat Std.Format))
def Lean.PrettyPrinter.OneLine.State.tags : Lean.PrettyPrinter.OneLine.State -> (List.{0} (Prod.{0, 0} Nat Std.Format)) :=
  fun (self : Lean.PrettyPrinter.OneLine.State) => self.3
