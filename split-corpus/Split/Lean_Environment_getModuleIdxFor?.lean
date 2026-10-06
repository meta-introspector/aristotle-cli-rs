import Mathlib

set_option pp.all true
-- spec: Lean.Environment.getModuleIdxFor? : Lean.Environment -> Lean.Name -> (Option.{0} Lean.ModuleIdx)
def Lean.Environment.getModuleIdxFor? : Lean.Environment -> Lean.Name -> (Option.{0} Lean.ModuleIdx) :=
  fun (env : Lean.Environment) (declName : Lean.Name) => GetElem?.getElem?.{0, 0, 0} (Std.HashMap.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName) Lean.Name Lean.ModuleIdx (fun (m : Std.HashMap.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName) (a : Lean.Name) => Membership.mem.{0, 0} Lean.Name (Std.HashMap.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName) (Std.HashMap.instMembership.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName) m a) (Std.HashMap.instGetElem?Mem.{0, 0} Lean.Name Lean.ModuleIdx Lean.Name.instBEq Lean.instHashableName) (Lean.Kernel.Environment.const2ModIdx (_private.Lean.Environment.0.Lean.VisibilityMap.get Lean.Kernel.Environment (_private.Lean.Environment.0.Lean.Environment.base env) env)) declName
