import Mathlib

set_option pp.all true
-- spec: Lean.LocalContext.fvarIdToDecl : Lean.LocalContext -> (Lean.PersistentHashMap.{0, 0} Lean.FVarId Lean.LocalDecl Lean.instBEqFVarId Lean.instHashableFVarId)
def Lean.LocalContext.fvarIdToDecl : Lean.LocalContext -> (Lean.PersistentHashMap.{0, 0} Lean.FVarId Lean.LocalDecl Lean.instBEqFVarId Lean.instHashableFVarId) :=
  fun (self : Lean.LocalContext) => self.1
