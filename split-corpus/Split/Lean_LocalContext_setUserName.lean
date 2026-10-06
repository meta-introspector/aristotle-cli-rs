import Mathlib

set_option pp.all true
-- spec: Lean.LocalContext.setUserName : Lean.LocalContext -> Lean.FVarId -> Lean.Name -> Lean.LocalContext
def Lean.LocalContext.setUserName : Lean.LocalContext -> Lean.FVarId -> Lean.Name -> Lean.LocalContext :=
  fun (lctx : Lean.LocalContext) (fvarId : Lean.FVarId) (userName : Lean.Name) => have decl : Lean.LocalDecl := Lean.LocalContext.get! lctx fvarId; have decl : Lean.LocalDecl := Lean.LocalDecl.setUserName decl userName; Lean.LocalContext.mk (Lean.PersistentHashMap.insert.{0, 0} Lean.FVarId Lean.LocalDecl Lean.instBEqFVarId Lean.instHashableFVarId (Lean.LocalContext.fvarIdToDecl lctx) (Lean.LocalDecl.fvarId decl) decl) (Lean.PersistentArray.set.{0} (Option.{0} Lean.LocalDecl) (Lean.LocalContext.decls lctx) (Lean.LocalDecl.index decl) (Option.some.{0} Lean.LocalDecl decl)) (Lean.LocalContext.auxDeclToFullName lctx)
