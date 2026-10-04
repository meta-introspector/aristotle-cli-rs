import Mathlib

set_option pp.all true
-- spec: Lean.EnvExtension.instInhabitedAsyncMode : Inhabited.{1} Lean.EnvExtension.AsyncMode
def Lean.EnvExtension.instInhabitedAsyncMode : Inhabited.{1} Lean.EnvExtension.AsyncMode :=
  Inhabited.mk.{1} Lean.EnvExtension.AsyncMode Lean.EnvExtension.instInhabitedAsyncMode.default
