import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.State.tableEntries : Lean.Meta.SynthInstance.State -> (Std.HashMap.{0, 0} Lean.Expr Lean.Meta.SynthInstance.TableEntry Lean.Expr.instBEq Lean.Expr.instHashable)
def Lean.Meta.SynthInstance.State.tableEntries : Lean.Meta.SynthInstance.State -> (Std.HashMap.{0, 0} Lean.Expr Lean.Meta.SynthInstance.TableEntry Lean.Expr.instBEq Lean.Expr.instHashable) :=
  fun (self : Lean.Meta.SynthInstance.State) => self.4
