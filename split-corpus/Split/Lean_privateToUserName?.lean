import Mathlib

set_option pp.all true
-- spec: Lean.privateToUserName? : Lean.Name -> (Option.{0} Lean.Name)
def Lean.privateToUserName? : Lean.Name -> (Option.{0} Lean.Name) :=
  fun (n : Lean.Name) => ite.{1} (Option.{0} Lean.Name) (Eq.{1} Bool (Lean.isPrivateName n) Bool.true) (instDecidableEqBool (Lean.isPrivateName n) Bool.true) (Option.some.{0} Lean.Name (_private.Lean.PrivateName.0.Lean.privateToUserNameAux n)) (Option.none.{0} Lean.Name)
