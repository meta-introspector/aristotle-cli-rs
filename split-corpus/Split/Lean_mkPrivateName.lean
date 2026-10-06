import Mathlib

set_option pp.all true
-- spec: Lean.mkPrivateName : Lean.Environment -> Lean.Name -> Lean.Name
def Lean.mkPrivateName : Lean.Environment -> Lean.Name -> Lean.Name :=
  fun (env : Lean.Environment) (n : Lean.Name) => Lean.mkPrivateNameCore (Lean.Environment.mainModule env) (Lean.privateToUserName n)
