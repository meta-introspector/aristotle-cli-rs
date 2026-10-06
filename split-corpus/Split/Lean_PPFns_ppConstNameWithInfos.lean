import Mathlib

set_option pp.all true
-- spec: Lean.PPFns.ppConstNameWithInfos : Lean.PPFns -> Lean.PPContext -> Lean.Name -> (IO Lean.FormatWithInfos)
def Lean.PPFns.ppConstNameWithInfos : Lean.PPFns -> Lean.PPContext -> Lean.Name -> (IO Lean.FormatWithInfos) :=
  fun (self : Lean.PPFns) => self.2
