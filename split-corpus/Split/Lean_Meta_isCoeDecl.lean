import Mathlib

set_option pp.all true
-- spec: Lean.Meta.isCoeDecl : Lean.Environment -> Lean.Name -> Bool
def Lean.Meta.isCoeDecl : Lean.Environment -> Lean.Name -> Bool :=
  fun (env : Lean.Environment) (declName : Lean.Name) => Lean.TagAttribute.hasTag Lean.Meta.coeDeclAttr env declName
