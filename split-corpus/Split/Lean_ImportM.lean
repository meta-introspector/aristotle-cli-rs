import Mathlib

set_option pp.all true
-- spec: Lean.ImportM : Type -> Type
def Lean.ImportM : Type -> Type :=
  ReaderT.{0, 0} Lean.ImportM.Context IO
