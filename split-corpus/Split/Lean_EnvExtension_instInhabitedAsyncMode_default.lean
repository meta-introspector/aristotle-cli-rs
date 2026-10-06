import Mathlib

set_option pp.all true
-- spec: Lean.EnvExtension.instInhabitedAsyncMode.default : Lean.EnvExtension.AsyncMode
def Lean.EnvExtension.instInhabitedAsyncMode.default : Lean.EnvExtension.AsyncMode :=
  Lean.EnvExtension.AsyncMode.sync
