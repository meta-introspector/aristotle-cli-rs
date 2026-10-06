import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.fileMap : Lean.Core.Context -> Lean.FileMap
def Lean.Core.Context.fileMap : Lean.Core.Context -> Lean.FileMap :=
  fun (self : Lean.Core.Context) => self.2
