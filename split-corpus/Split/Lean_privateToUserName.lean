import Mathlib

set_option pp.all true
-- spec: Lean.privateToUserName : Lean.Name -> Lean.Name
def Lean.privateToUserName : Lean.Name -> Lean.Name :=
  fun (n : Lean.Name) => ite.{1} Lean.Name (Eq.{1} Bool (Lean.isPrivateName n) Bool.true) (instDecidableEqBool (Lean.isPrivateName n) Bool.true) (_private.Lean.PrivateName.0.Lean.privateToUserNameAux n) n
