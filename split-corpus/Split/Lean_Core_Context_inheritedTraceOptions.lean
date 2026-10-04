import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.inheritedTraceOptions : Lean.Core.Context -> (Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName)
def Lean.Core.Context.inheritedTraceOptions : Lean.Core.Context -> (Std.HashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Core.Context) => self.16
