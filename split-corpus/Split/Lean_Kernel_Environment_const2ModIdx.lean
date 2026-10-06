import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.const2ModIdx : Lean.Kernel.Environment -> (Std.HashMap.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName)
def Lean.Kernel.Environment.const2ModIdx : Lean.Kernel.Environment -> (Std.HashMap.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Kernel.Environment) => self.4
