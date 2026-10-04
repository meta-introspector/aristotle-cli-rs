import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.enableDiag : Lean.Environment -> Bool -> Lean.Environment
def Lean.Kernel.enableDiag : Lean.Environment -> Bool -> Lean.Environment :=
  fun (env : Lean.Environment) (flag : Bool) => _private.Lean.Environment.0.Lean.Environment.modifyCheckedAsync env (fun (x._@.Lean.Environment.2380704743._hygCtx._hyg.8 : Lean.Kernel.Environment) => Lean.Kernel.Environment.enableDiag x._@.Lean.Environment.2380704743._hygCtx._hyg.8 flag)
