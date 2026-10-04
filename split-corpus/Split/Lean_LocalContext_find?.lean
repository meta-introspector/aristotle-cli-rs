import Mathlib

set_option pp.all true
-- spec: Lean.LocalContext.find? : Lean.LocalContext -> Lean.FVarId -> (Option.{0} Lean.LocalDecl)
def Lean.LocalContext.find? : Lean.LocalContext -> Lean.FVarId -> (Option.{0} Lean.LocalDecl) :=
  fun (lctx : Lean.LocalContext) (fvarId : Lean.FVarId) => Lean.PersistentHashMap.find?.{0, 0} Lean.FVarId Lean.LocalDecl Lean.instBEqFVarId Lean.instHashableFVarId (Lean.LocalContext.fvarIdToDecl lctx) fvarId
