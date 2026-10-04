import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.enableDiag : Lean.Kernel.Environment -> Bool -> Lean.Kernel.Environment
def Lean.Kernel.Environment.enableDiag : Lean.Kernel.Environment -> Bool -> Lean.Kernel.Environment :=
  fun (env : Lean.Kernel.Environment) (flag : Bool) => _private.Lean.Environment.0.Lean.Kernel.Environment.mk (Lean.Kernel.Environment.constants env) (Lean.Kernel.Environment.quotInit env) (have __src._@.Lean.Environment.2380704742._hygCtx._hyg.11 : Lean.Kernel.Diagnostics := Lean.Kernel.Environment.diagnostics env; Lean.Kernel.Diagnostics.mk (Lean.Kernel.Diagnostics.unfoldCounter __src._@.Lean.Environment.2380704742._hygCtx._hyg.11) flag) (Lean.Kernel.Environment.const2ModIdx env) (_private.Lean.Environment.0.Lean.Kernel.Environment.extensions env) (_private.Lean.Environment.0.Lean.Kernel.Environment.irBaseExts env) (Lean.Kernel.Environment.header env)
